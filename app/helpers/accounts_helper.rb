module AccountsHelper
  def require_kpi(account)
    account.enable_kpi ? 'This account does have KPI.' : "This account doesn't require KPI."
  end

  def site_with_color(account)
    color_classes = {
      hideout: 'bg-blue-100 text-blue-800',
      sanctum: 'bg-green-100 text-green-800',
      foundry: 'bg-indigo-100 text-indigo-800',
      remote: 'bg-pink-100 text-pink-800'
    }

    site_name = account.site.to_s.humanize
    color_class = color_classes[account.site&.to_sym] || ''

    content_tag(:div, site_name, class: "inline px-3 py-1 text-sm font-normal rounded-full #{color_class} gap-x-2")
  end
end
