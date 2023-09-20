module SchedulesHelper
  def schedule_category_color(schedule)
    case schedule.category
    when 'coaching'
      'bg-paleFern'
    when 'qa'
      'bg-coral'
    when 'meeting'
      'bg-gold'
    else
      'bg-paleFern'
    end
  end
end
