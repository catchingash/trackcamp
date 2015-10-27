window.tc = window.tc || {};

tc.Event = function(graphType) {
  $('.btn-graph.event').click(this.handleClick.bind(this));

  this.formatMethod;
  this.graphMethod;
  this.graphContainer;
  this.graph;
  this.eventType;
}

tc.Event.prototype.handleClick = function(event) {
  event.preventDefault();
  var target = $(event.target);

  this.eventType = target.attr('data-eventType');

  var graphType = target.attr('data-graphType');
  this.formatMethod = this['formatDataFor_' + graphType];
  this.graphMethod = this[graphType];
  this.graphContainer = $('<div class="graph event event-' + graphType + ' event-' + this.eventType + '">');
  this.graph = $('.graph.event-' + this.eventType);

  this.toggleGraph();
}

tc.Event.prototype.toggleGraph = function() {
  // if we've already created the graph, show/hide it
  // else, create the graph
  if (this.graph.length > 0) {
    this.graph.toggleClass('hidden');
  } else {
    this.createGraph();
  }
}

tc.Event.prototype.createGraph = function() {
  // if we already have the data, create the graph
  // else, fetch the data, THEN create the graph
  if (tc.dataRepo.events[this.eventType]) {
    var formattedData = this.formatMethod(tc.dataRepo.events[this.eventType]);
    this.graphMethod(formattedData);
  } else {
    var url = '/events?event_type=' + this.eventType;

    $.ajax({ url: url,
      method: 'GET',
      success: function(res) {
        tc.dataRepo.events[this.eventType] = res;
        var formattedData = this.formatMethod(res);
        this.graphMethod(formattedData);
      }.bind(this)
    });
  }
}

// [ { "time":1445951700000, "rating":138.6, "note":"", "event_type":"weight" } ]
tc.Event.prototype.formatDataFor_lineGraph = function(events) {
  var data_points = []

  for (var i = 0; i < events.length; i++) {
    var pointData = events[i];
    var point = { note: pointData['note'], x: pointData['time'], y: pointData['rating'] };
    data_points.push(point)
  }

  return data_points;
}

tc.Event.prototype.lineGraph = function(data_points) {
  // this order causes 2 DOM redraws instead of 1; however,
  // this is necessary for the chart width to be correct.
  $('.graphs').append(this.graphContainer);

  this.graphContainer.highcharts({
    chart: { zoomType: 'x' },
    title: { text: this.eventType },
    xAxis: {
      type: 'datetime',
      labels: { format: '{value:%a<br>%b %d}' }
    },
    yAxis: {
      title: { text: 'Number/Rating' },
      labels: {
        formatter: function () {
          return this.value;
        }
      }
    },
    tooltip: {
      headerFormat: '<b>{series.name}</b><br>',
      // Tue, Oct 27 at 9:58 AM
      // 139
      pointFormat: '{point.x:%a, %b %d at %l:%M %p}<br>{point.y:.0f}<br>{point.note}'
    },
    plotOptions: {
      area: { fillOpacity: 0.5 },
    },
    credits: { enabled: false },
    series: [{
      name: this.eventType,
      data: data_points
    }]
  });
}
