module TestsHelper
  def searchable(id)
    buf = <<-EOF
    <input class="autocomplete" type="text" placeholder="filter" id="search-for-#{id}">
    <style id="search-style-for-#{id}"></style>
    <script type="text/javascript">
      var searchStyle = document.getElementById('search-style-for-#{id}');
      document.getElementById('search-for-#{id}').addEventListener('input', function() {
        if (!this.value) {
          searchStyle.innerHTML = "";
          return;
        }
        searchStyle.innerHTML = '##{id} .searchable:not([data-index*="' + this.value.toLowerCase().replace(/"/g, '') + '"]) { display: none; }';
});
    </script>
    EOF
    buf.html_safe
  end

  def link_to_suite(suite)
    return if suite.nil?
    klass = 'icon ' + ((suite.archived? && 'icon-lock') || (suite.executable? && 'icon-folder-open') || 'icon-folder')
    link_to "##{suite.id} #{suite.title}", {:action => :show, :controller => :test_suites, :id => suite.id}, :class => klass
  end

  def link_to_case(kase)
    return if kase.nil?
    link_to "##{kase.id} #{kase.title}", {:action => :show, :controller => :test_cases, :id => kase.id}, :class => "icon icon-bolt"
  end

  def link_to_execution(execution)
    return if execution.nil?
    url = url_for :controller => :test_executions, :action => :show, :id => execution.id
    ("<a href='#{url}'>" +
    execution.statuses.map do |id, cases|
      klass = TestLog::STATUS[id].parameterize
      "<strong class='#{klass}'>#{cases.size}</strong>"
    end.join + "</a>").html_safe
  end

  def log_status(log)
    return if log.nil?
    klass = TestLog::STATUS[log.status].parameterize
    "<strong class='#{klass}'>#{TestLog::STATUS[log.status]}</strong>".html_safe
  end
end
