module CoachingHelper
  def display_week(coaching)
    coaching.acknowledged?
  end

  def formatted_date(start_date, end_date)
    formatted_start_date = start_date.strftime('%B %d, %Y')
    formatted_end_date = end_date.strftime('%B %d, %Y')

    "#{formatted_start_date} - #{formatted_end_date}"
  end

  def display_acknowledgement_date(coaching)
    return 'Please acknowledge' unless coaching.acknowledgement

    time_tag coaching.date_acknowledged, 'data-local': 'time-ago'
  end

  def acknowledged_count_per_week(coaching, acknowledgement)
    result = {}
    acknowledged = {}

    coaching.each do |date, value|
      acknowledged[date] = acknowledgement[date] || 0
      result[date] = { value:, acknowledged: acknowledged[date] }
    end

    result
  end
end
