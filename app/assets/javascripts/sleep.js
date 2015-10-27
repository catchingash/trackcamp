window.tc = window.tc || {};

tc.Sleep = function(graphType) {
  $('.btn-graph.sleep').click(this.handleClick.bind(this));

  this.formatMethod;
  this.graphMethod;
  this.graphContainer;
  this.graph;
}

tc.Sleep.prototype.handleClick = function(event) {
  event.preventDefault();

  graphType = $(event.target).attr('data-graphType')
  this.formatMethod = this['formatDataFor_' + graphType];
  this.graphMethod = this[graphType];
  this.graphContainer = $('<div class="graph sleep sleep-' + graphType + '">');
  this.graph = $('.graph.sleep-' + graphType);

  this.toggleGraph();
}

tc.Sleep.prototype.toggleGraph = function() {
  // if we've already created the graph, show/hide it
  // else, create the graph
  if (this.graph.length > 0) {
    this.graph.toggleClass('hidden');
  } else {
    this.createGraph();
  }
}

tc.Sleep.prototype.createGraph = function() {
  // if we already have the data, create the graph
  // else, fetch the data, THEN create the graph
  if (tc.dataRepo.sleeps.length > 0) {
    var formattedData = this.formatMethod(tc.dataRepo.sleeps);
    this.graphMethod(formattedData);
  } else {
    $.ajax({url: '/sleep',
      method: 'GET',
      success: function(res) {
        tc.dataRepo.sleeps = res;
        var formattedData = this.formatMethod(res);
        this.graphMethod(formattedData);
      }.bind(this)
    });
  }
}

// NOTE: see below for example
tc.Sleep.prototype.formatDataFor_sharkFins = function(sleeps) {
  var formatted = [{
    type: 'area',
    name: 'Sleep',
    data: []
  }];

  for (var i = 0; i < sleeps.length; i++) {
    var sleep = sleeps[i];

    // format the data in the way that Highcharts wants
    var data1 = [ sleep.started_at, 0]
    var data2 = [ sleep.ended_at, (sleep.ended_at - sleep.started_at)/3600000 ] // y-value = sleep duration in hours. // NOTE: 3600000 ms == 1 hour
    var data3 = [ sleep.ended_at + 1, null ] // this makes the graph line break after this sleep

    // add the formatted data to the correct index position (where the matching sleep type is located)
    formatted[0].data.push(data1);
    formatted[0].data.push(data2);
    formatted[0].data.push(data3);
  }

  return formatted;
}

tc.Sleep.prototype.sharkFins = function(activity_series) {
  // this order causes 2 DOM redraws instead of 1; however,
  // this is necessary for the chart width to be correct.
  $('.graphs').append(this.graphContainer);

  this.graphContainer.highcharts({
    chart: { zoomType: 'x' },
    title: { text: 'Sleep (Per Session)' },
    xAxis: {
      title: { text: 'Date' },
      type: 'datetime',
      // 12 AM
      // Oct 02
      labels: { format: '{value:%l %p<br>%b %d}' }
    },
    yAxis: {
      title: { text: 'Hours' },
      labels: {
        formatter: function () {
          return this.value;
        }
      }
    },
    tooltip: {
      headerFormat: '<b>{series.name}</b><br>',
      // 7:54 AM: 2.88 hours
      pointFormat: '{point.x:%l:%M %p}: {point.y:.2f} hours'
    },
    plotOptions: {
      area: { fillOpacity: 0.5 }
    },
    credits: { enabled: false },
    series: activity_series
  });
}

tc.Sleep.prototype.formatDataFor_lineGraph = function(sleeps) {
  var sums = {};

  // collect the total time across all sleeps for each day
  for (var i = 0; i < sleeps.length; i++) {
    var sleep = sleeps[i];
    var duration = (sleep.ended_at - sleep.started_at); // in milliseconds
    var time = new Date(sleep.ended_at);
    // selects noon on that day, in milliseconds since epoch
    var day = new Date(time.getFullYear(), time.getMonth(), time.getDate(), 12).valueOf();

    sums[day] = sums[day] ? sums[day] + duration : duration
  }

  var times = Object.keys(sums);
  var duration_series = [];

  // format times for the graph: [[date, duration], ... , [date, duration]]
  for (var i = 0; i < times.length; i++) {
    var time = times[i];
    var data_point = [parseInt(time), sums[time]/3600000];
    duration_series.push(data_point);
  }

  return duration_series;
}

tc.Sleep.prototype.lineGraph = function(duration_series) {
  // this order causes 2 DOM redraws instead of 1; however,
  // this is necessary for the chart width to be correct.
  $('.graphs').append(this.graphContainer);

  this.graphContainer.highcharts({
    chart: { zoomType: 'x' },
    title: { text: 'Sleep (Per Day)' },
    xAxis: {
      title: { text: 'Date' },
      type: 'datetime',
      // Mon
      // Oct 05
      labels: { format: '{value:%a<br>%b %d}' },
      minTickInterval: 86400000, // min interval: 1 day
      tickPositioner: function() {
        // fetches default positions, which are at midnight
        var positions = this.tickPositions;

        // shifts each time by 12 hours, so the tick marks are at midday
        // which lines up with the midday data points
        for (var i = 0; i < positions.length; i++) {
          positions[i] += 43200000; // shifts by 12 hours
        }

        return positions;
      }
    },
    yAxis: {
      title: { text: 'Hours' },
      labels: {
        formatter: function () {
          return this.value;
        }
      }
    },
    tooltip: {
      headerFormat: '<b>{series.name}</b><br>',
      // Wed, Aug 19: 7.58 hours
      pointFormat: '{point.x:%a, %b %d}: {point.y:.2f} hours'
    },
    plotOptions: {
      area: { fillOpacity: 0.5 }
    },
    credits: { enabled: false },
    series: [{
      name: 'Sleep',
      data: duration_series
    }]
  });
}

// // result of tc.Sleep.prototype.formatDataForSharkFins:
// [{
//   name: 'Sleep',
//   data: [
//     [1443642605000, 0],
//     [1443645944000, 0.9275],
//     [1443645944001, null],
//     [1443665371000, 0],
//     [1443666716000, 0.37361111111],
//   ]
// }]
