// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

window.tc = window.tc || {};

$(document).ready(function() {
  tc.dataRepo = new tc.DataRepository();
  new tc.Activity();
  new tc.Sleep();
  new tc.Event();

  $('.btn.new-event').click(function(event) {
    $('form.new_event').toggleClass('hidden');
    $(event.target).toggleClass('active');
  });

  $('.btn.new-event-type').click(tc.toggleNewEventTypeForm);
  $('form.popup .btn-close').click(tc.toggleNewEventTypeForm);
});

tc.toggleNewEventTypeForm = function(e) {
  $('form.new_event_type').toggleClass('hidden');
  $('.icon-settings').parent().toggleClass('active');
}

tc.syncExtremes = function(e) {
  var thisChart = this.chart;

  Highcharts.each(Highcharts.charts, function (chart) {
    if (chart !== thisChart) {
      if (chart.xAxis[0].setExtremes) { // It is null while updating
        chart.xAxis[0].setExtremes(e.min, e.max);
      }
    }
  });
}
