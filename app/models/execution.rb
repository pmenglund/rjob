require 'net/ssh'
require 'net/sftp'

class Execution < ActiveRecord::Base
    belongs_to :job

    attr_accessible :job_id, :host, :result, :stdout, :stderr

    STATUS = %w{queued running exception failed}

    def perform
        Rjob.info "running job..."
        self.status = 1
        self.save

        begin
            run_job
        rescue Exception => e
            Rjob.notice("caught exception: #{e.message}")
            self.status = 3
            self.stderr = e.message
        end
        self.save

        Rjob.info "job completed!"
    end

    def on_permanent_failure
        Rjob.notice("failed to execute")
        self.status = 4
        self.save
    end

    def run_job
        Net::SSH.start(host, job.user, {:auth_methods => %w{publickey}}) do |ssh|
            Rjob.debug "ssh session open"

            # ssh to client
            # TODO: add timeout for command
            channel = ssh.open_channel do |ch|
                Rjob.info "#{job.user}@#{host}: executing '#{job.command}'"
                ch.exec job.command do |ch, success|
                    unless success
                        Rjob.debug "ssh command failed"
                        raise "could not execute command: '#{job.command}'"
                    end

                    # "on_data" is called when the process writes something to stdout
                    ch.on_data do |c, data|
                        self.stdout += data
                        Rjob.debug "got stdout: #{data}"
                    end

                    # "on_extended_data" is called when the process writes something to stderr
                    ch.on_extended_data do |c, type, data|
                        self.stderr += data
                        Rjob.debug "got stderr: #{data}"
                    end

                    ch.on_request "exit-status" do |c, data|
                        self.result = data.read_long
                        Rjob.debug "process terminated with exit status: #{data.read_long.to_s}"
                    end

                    ch.on_close { Rjob.debug "channel closed!" }
                end
            end
            channel.wait
            Rjob.debug "ssh channel done"

            self.status = 2
        end
    end
end
