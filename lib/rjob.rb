module Rjob

    @levels = [:debug, :info, :notice, :warning, :err, :alert, :emerg, :crit]
    @loglevel = ENV["RAILS_ENV"] == "development" ? 0 : 2

    def self.loglevel
        return @levels[@loglevel]
    end

    def self.loglevel=(level)
        raise "Unknown log level" unless level.is_a(Symbol)

        unless @levels.include?(level)
            raise Rjob::DevError, "Invalid loglevel %s" % level
        end

        @loglevel = @levels.index(level)
    end

    def self.debug(msg)
        message(:debug, msg)
    end

    def self.info(msg)
        message(:info, msg)
    end

    def self.notice(msg)
        message(:notice, msg)
    end

    private

    def self.message(level, msg)
        STDERR.puts("#{level}: #{msg}") if @levels.index(level) >= @loglevel
    end
end