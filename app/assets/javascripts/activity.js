window.tc = window.tc || {};

tc.Activity = function(graphType) {
  $('.btn-graph.activity').click(this.handleClick.bind(this));

  this.formatMethod;
  this.graphMethod;
  this.graphContainer;
  this.graph;
}

tc.Activity.prototype.handleClick = function(event) {
  event.preventDefault();

  graphType = $(event.target).attr('data-graphType')
  this.formatMethod = this['formatDataFor_' + graphType];
  this.graphMethod = this[graphType];
  this.graphContainer = $('<div class="graph activity activity-' + graphType + '">');
  this.graph = $('.graph.activity-' + graphType);

  this.toggleGraph();
}

tc.Activity.prototype.toggleGraph = function() {
  // if we've already created the graph, show/hide it
  // else, create the graph
  if (this.graph.length > 0) {
    this.graph.toggleClass('hidden');
  } else {
    this.createGraph();
  }
}

tc.Activity.prototype.createGraph = function() {
  // if we already have the data, create the graph
  // else, fetch the data, THEN create the graph
  if (tc.dataRepo.activities.length > 0) {
    var formattedData = this.formatMethod(tc.dataRepo.activities);
    this.graphMethod(formattedData);
  } else {
    $.ajax({url: '/activities',
      method: 'GET',
      success: function(res) {
        tc.dataRepo.activities = res;
        var formattedData = this.formatMethod(res);
        this.graphMethod(formattedData);
      }.bind(this)
    });
  }
}

// NOTE: see below for example
tc.Activity.prototype.formatDataFor_sharkFins = function(activities) {
  var formatted = [];

  for (var i = 0; i < activities.length; i++) {
    var activity = activities[i];
    var found = false;
    var index;

    for (var j = 0; j < formatted.length; j++) {
      // if this is the matching activity type, save the index
      if (formatted[j].name == activity.activity_type) {
        found = true;
        index = j;
        break;
      }
    }

    // if we didn't find the matching activity type, create a new activity type and save its index
    if (!found) {
      found = true;
      index = formatted.length; // this will be the index of the object added below

      formatted.push({
        type: 'area',
        name: activity.activity_type,
        data: []
      });
    }

    // format the data in the way that Highcharts wants
    var data1 = [ activity.started_at, 0]
    var data2 = [ activity.ended_at, (activity.ended_at - activity.started_at)/60000 ] // y-value = activity duration in minutes. // NOTE: 60000 ms == 1 min
    var data3 = [ activity.ended_at + 1, null ] // this makes the graph line break after this activity

    // add the formatted data to the correct index position (where the matching activity type is located)
    formatted[index].data.push(data1);
    formatted[index].data.push(data2);
    formatted[index].data.push(data3);
  }

  return formatted;
}

tc.Activity.prototype.sharkFins = function(activity_series) {
  // this order causes 2 DOM redraws instead of 1; however,
  // this is necessary for the chart width to be correct.
  $('.graphs').append(this.graphContainer);

  this.graphContainer.highcharts({
    chart: { zoomType: 'x' },
    title: { text: 'Activities (Minutes Per Session)' },
    xAxis: {
      title: { text: 'Date' },
      type: 'datetime',
      labels: { format: '{value:%l %p<br>%b %d}' }
    },
    yAxis: {
      title: { text: 'Minutes' },
      labels: {
        formatter: function () {
          return this.value;
        }
      }
    },
    tooltip: {
      headerFormat: '<b>{series.name}</b><br>',
      pointFormat: '{point.x:%l:%M %p}: {point.y:.0f} min'
    },
    plotOptions: {
      area: { fillOpacity: 0.5 }
    },
    credits: { enabled: false },
    series: activity_series
  });
}

tc.Activity.prototype.formatDataFor_lineGraph = function(activities) {
  var sums = {};

  // collect the total time across all activities for each day
  for (var i = 0; i < activities.length; i++) {
    var activity = activities[i];
    var duration = (activity.ended_at - activity.started_at); // in milliseconds
    var time = new Date(activity.started_at);
    var day = new Date(time.getFullYear(), time.getMonth(), time.getDate(), 12).valueOf(); // selects noon on that day, in milliseconds since epoch

    if (sums[day]) {
      sums[day] += duration;
    } else {
      sums[day] = duration;
    }
  }

  var times = Object.keys(sums);
  var duration_series = [];

  // format times for the graph: [[date, duration], ... , [date, duration]]
  for (var i = 0; i < times.length; i++) {
    var time = times[i];
    var data_point = [parseInt(time), Math.round(sums[time]/60000)]; // [ date, duration (rounded to the nearest minute) ]
    duration_series.push(data_point);
  }

  return duration_series;
}

tc.Activity.prototype.lineGraph = function(duration_series) {
  // this order causes 2 DOM redraws instead of 1; however,
  // this is necessary for the chart width to be correct.
  $('.graphs').append(this.graphContainer);

  this.graphContainer.highcharts({
    chart: { zoomType: 'x' },
    title: { text: 'Activities (Minutes Per Day)' },
    xAxis: {
      title: { text: 'Date' },
      type: 'datetime',
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
      title: { text: 'Minutes' },
      labels: {
        formatter: function () {
          return this.value;
        }
      }
    },
    tooltip: {
      headerFormat: '<b>{series.name}</b><br>',
      pointFormat: '{point.x:%a, %b %d}: {point.y:.0f} min'
    },
    plotOptions: {
      area: { fillOpacity: 0.5 }
    },
    credits: { enabled: false },
    series: [{
      name: 'Activites',
      data: duration_series
    }]
  });
}

// // result of tc.Activity.prototype.formatDataForSharkFins:
// [
//   {
//     name: 'Walking',
//     data: [
//       [1443642605000, 0],
//       [1443645944000, 55],
//       [1443645944001, null],
//       [1443665371000, 0],
//       [1443666716000, 22],
//     ]
//   },
//   {
//     name: 'Calisthenics',
//     data: [
//       [1443642303000, 0],
//       [1443642303000, 8],
//       [1443642303001, null],
//       [1443656383000, 0]
//       [1443656383000, 20]
//       [1443656383001, null]
//     ]
//   }
// ]
