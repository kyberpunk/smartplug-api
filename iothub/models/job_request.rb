require_relative 'direct_method'
require_relative 'twin'

class JobRequest
  attr_accessor :job_id
  attr_accessor :type
  attr_accessor :cloud_to_device_method
  attr_accessor :update_twin
  attr_accessor :query_condition
  attr_accessor :start_time
  attr_accessor :max_execution_time

  def as_json
    { jobId: job_id, type: type,
      cloudToDeviceMethod: cloud_to_device_method.as_json,
      updateTwin: update_twin.as_json, queryCondition: query_condition,
      startTime: start_time.iso8601,
      maxExecutionTimeInSeconds: max_execution_time }
  end
end

class JobStatistics
  attr_accessor :device_count
  attr_accessor :failed_count
  attr_accessor :succeeded_count
  attr_accessor :running_count
  attr_accessor :pending_count

  def self.create(hash)
    obj = JobStatistics.new
    obj.device_count = hash[:deviceCount].to_i
    obj.failed_count = hash[:failedCount].to_i
    obj.succeeded_count = hash[:succeededCount].to_i
    obj.running_count = hash[:runningCount].to_i
    obj.pending_count = hash[:pendingCount].to_i
    obj
  end
end

class JobResponse
  attr_accessor :job_id
  attr_accessor :type
  attr_accessor :cloud_to_device_method
  attr_accessor :update_twin
  attr_accessor :query_condition
  attr_accessor :created_time
  attr_accessor :start_time
  attr_accessor :end_time
  attr_accessor :max_execution_time
  attr_accessor :status
  attr_accessor :failure_reason
  attr_accessor :status_message
  attr_accessor :job_statistics

  def self.create(hash)
    obj = JobResponse.new
    obj.job_id = hash[:jobId]
    obj.type = hash[:type].to_sym
    obj.cloud_to_device_method = DirectMethod.create(hash[:cloudToDeviceMethod])
    obj.update_twin = Twin.create(hash[:updateTwin])
    obj.query_condition = hash[:queryCondition]
    obj.created_time = Time.iso8601(hash[:createdTime])
    obj.start_time = Time.iso8601(hash[:startTime])
    obj.end_time = Time.iso8601(hash[:endTime])
    obj.max_execution_time = hash[:maxExecutionTimeInSeconds].to_i
    obj.status = hash[:status].to_sym
    obj.failure_reason = hash[:failureReason]
    obj.status_message = hash[:statusMessage]
    obj.job_statistics = JobStatistics.create(hash[:deviceJobStatistics])
    obj
  end
end

class QueryResultWithContinuation
  attr_accessor :value
  attr_accessor :next_link

  def self.create(hash)
    obj = QueryResultWithContinuation.new
    obj.value = hash[:value]
    obj.next_link = hash[:next_link]
    obj
  end
end