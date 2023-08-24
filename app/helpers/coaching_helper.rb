module CoachingHelper
  def display_week(coaching)
    coaching.acknowledged?
  end

  def display_acknowledgement_date(coaching)
    return 'Please acknowledge' unless coaching.acknowledgement

    time_tag coaching.date_acknowledged, 'data-local': 'time-ago'
  end
end
