module SchedulesHelper
  def schedule_category_color(schedule)
    case schedule.category
    when 'coaching'
      'bg-paleFern'
    when 'qa'
      'bg-paleCoral'
    when 'meeting'
      'bg-gold'
    else
      'bg-coral'
    end
  end
end
