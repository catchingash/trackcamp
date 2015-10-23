function ActivityHandler(graphType) {
  this.formatMethod = this['formatDataFor_' + graphType];
  this.graphMethod = this[graphType];
  this.graphContainer = $('<div class="graph activity activity-' + graphType + '">');
  this.graph = $('.graph.activity-' + graphType);
}

ActivityHandler.prototype.toggleGraph = function() {
  // if we've already created the graph, show/hide it
  // else, create the graph
  if (this.graph.length > 0) {
    this.graph.toggleClass('hidden');
  } else {
    this.createGraph();
  }
}

ActivityHandler.prototype.createGraph = function() {
  // if we already have the data, create the graph
  // else, fetch the data, THEN create the graph
  if (dataRepo.activities.length > 0) {
    var formattedData = this.formatMethod(dataRepo.activities);
    this.graphMethod(formattedData);
  } else {
    $.ajax({url: '/activities',
      method: 'GET',
      success: function(res) {
        dataRepo.activities = res;
        var formattedData = this.formatMethod(res);
        this.graphMethod(formattedData);
      }.bind(this)
    });
  }
}

// NOTE: see below for example
ActivityHandler.prototype.formatDataFor_sharkFins = function(activities) {
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
    var data1 = [ activity.start_time, 0]
    var data2 = [ activity.end_time, (activity.end_time - activity.start_time)/60000 ] // y-value = activity duration in minutes. // NOTE: 60000 ms == 1 min
    var data3 = [ activity.end_time + 1, null ] // this makes the graph line break after this activity

    // add the formatted data to the correct index position (where the matching activity type is located)
    formatted[index].data.push(data1);
    formatted[index].data.push(data2);
    formatted[index].data.push(data3);
  }

  return formatted;
}

ActivityHandler.prototype.sharkFins = function(activity_series) {
  // this order causes 2 DOM redraws instead of 1; however,
  // this is necessary for the chart width to be correct.
  $('.graphs').append(this.graphContainer);

  this.graphContainer.highcharts(
    {
      chart: {
          zoomType: 'x'
      },
      title: {
          text: 'Activities (Minutes Per Session)'
      },
      // legend: {
      //     layout: 'vertical',
      //     align: 'left',
      //     verticalAlign: 'top',
      //     x: 75,
      //     y: 50,
      //     floating: true,
      //     borderWidth: 1,
      //     backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
      // },
      xAxis: {
        title: {
          text: 'Date'
        },
        type: 'datetime',
        labels: {
          format: '{value:%l %p<br>%b %d}'
        }
      },
      yAxis: {
          title: {
              text: 'Minutes'
          },
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
          area: {
              fillOpacity: 0.5
          }
      },
      credits: {
          enabled: false
      },
      series: activity_series
    }
  );
}

ActivityHandler.prototype.formatDataFor_lineGraph = function(activities) {
  var sums = {};

  // collect the total time across all activities for each day
  for (var i = 0; i < activities.length; i++) {
    var activity = activities[i];
    var duration = (activity.end_time - activity.start_time); // in milliseconds
    var time = new Date(activity.start_time);
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

ActivityHandler.prototype.lineGraph = function(duration_series) {
  // this order causes 2 DOM redraws instead of 1; however,
  // this is necessary for the chart width to be correct.
  $('.graphs').append(this.graphContainer);

  this.graphContainer.highcharts(
    {
      chart: {
          zoomType: 'x'
      },
      title: {
          text: 'Activities (Minutes Per Day)'
      },
      // legend: {
      //     layout: 'vertical',
      //     align: 'left',
      //     verticalAlign: 'top',
      //     x: 75,
      //     y: 50,
      //     floating: true,
      //     borderWidth: 1,
      //     backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
      // },
      xAxis: {
        title: {
          text: 'Date'
        },
        type: 'datetime',
        labels: {
          format: '{value:%a<br>%b %d}'
        }
      },
      yAxis: {
          title: {
              text: 'Minutes'
          },
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
          area: {
              fillOpacity: 0.5
          }
      },
      credits: {
          enabled: false
      },
      series: [{
        name: 'Duration in minutes',
        data: duration_series
      }]
    }
  );
}

// // result of ActivityHandler.prototype.formatDataForSharkFins:
// [
//   {
//     name: 'Walking',
//     data: [
//       [1443642605000, 0],
//       [1443645944000, (1443645944-1443642605)/60000],
//       [1443645944001, null],
//       [1443665371000, 0],
//       [1443666716000, (1443666716-1443665371)/60000],
//     ]
//   },
//   {
//     name: 'Calisthenics',
//     data: [
//       [1443642303000, 0],
//       [1443642303000, (1444912303-1444911779)/60000],
//       [1443642303001, null],
//       [1443656383000, 0]
//       [1443656383000, (1444916383-1444915142)/60000]
//       [1443656383001, null]
//     ]
//   }
// ]
