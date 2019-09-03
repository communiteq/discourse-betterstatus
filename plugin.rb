# name: discourse-betterstatus
# about: arrange better status information at /srv/status
# version: 1.0
# authors: DiscourseHosting.com
# url: https://github.com/discoursehosting/discourse-betterstatus

after_initialize do
  module ::BetterStatus
    def status
      if $shutdown
        render plain: "shutting down", status: 500
      else
        st = 200
        output = 'ok'
        begin
          test = $redis.get('xyz')
        rescue
          output = 'redis down'
          st = 500
        end

        begin
          test = User.find(1)
        rescue
          output = 'postgres down'
          st = 500
        end

        render plain: output, status: st
      end

    end
  end

  class ::ForumsController
    prepend BetterStatus
  end
end
