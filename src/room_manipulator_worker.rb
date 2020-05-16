
# class RoomManipulatorWorker

#   def initialize(queue)
#     @thread = Thread.start(queue) do |queue|
#       loop do
#         e = queue.pop
#         break if e.nil?
#         process e
#       end
#     end
#   end

#   def kill
#     @thread.kill
#   end

#   def status
#     # "run", "sleep", "aborting", false(success halt), nil(error halt)
#     @thread.status
#   end

#   def push
#   end

#   # - - - - - - - - - - - - - - - - - -
#   # internal

#   def process e
#   end
#   private :process

# end