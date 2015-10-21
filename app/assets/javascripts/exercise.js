function ExerciseRepository() {
  this.data = [];
  // // this.data format example:
  // [
  //   {"start_time":1442715161266, "end_time":1442715751717, "activity_type":"Calisthenics", "data_source":"com.popularapp.sevenmins:session_activity_segment"},
  //   {"start_time":1442761964988, "end_time":1442762569288, "activity_type":"Calisthenics", "data_source":"com.popularapp.sevenmins:session_activity_segment"},
  //   {"start_time":1443625200000, "end_time":1443626400000, "activity_type":"Walking", "data_source":"google.android.apps.fitness:LGE:Nexus 4:ff13169d2dfaa15d:user_input"},
  //   {"start_time":1443642605208, "end_time":1443645944057, "activity_type":"Walking", "data_source":"com.google.android.gms:LGE:Nexus 4:ff13169d2dfaa15d:from_sample\u003c-derived:com.google.activity.sample:com.google.android.gms:LGE:Nexus 4:ff13169d2dfaa15d:detailed"}
  // ]
}

ExerciseRepository.prototype.toggleExerciseA = function() {
  var graph = $('.graph.exercise-a');
  // if we've already created the graph, show/hide it
  // else, create the graph
  if (graph.length > 0) {
    graph.toggleClass('hidden');
  } else {
    this.createExerciseA();
  }
}

ExerciseRepository.prototype.createExerciseA = function() {
  // if we already have the data, create the graph
  // else, fetch the data, THEN create the graph
  if (this.data.length > 0) {
    var formatted_data = this.formatDataForSharkFins(this.data);
    this.sharkFins(formatted_data);
  } else {
    $.ajax({url: '/activities',
      method: 'GET',
      success: function(res) {
        this.data = res;
        var formatted_data = this.formatDataForSharkFins(res);
        this.sharkFins(formatted_data);
      }.bind(this)
    });
  }
}

// NOTE: see below for example
ExerciseRepository.prototype.formatDataForSharkFins = function(activities) {
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

ExerciseRepository.prototype.sharkFins = function(activity_series) {
  var container = $('<div class="graph exercise exercise-a">');

  container.highcharts(
    {
      chart: {
          zoomType: 'x'
      },
      title: {
          text: 'Activities'
      },
      legend: {
          layout: 'vertical',
          align: 'left',
          verticalAlign: 'top',
          x: 75,
          y: 50,
          floating: true,
          borderWidth: 1,
          backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
      },
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

  $('.graphs').append(container);
}

// // result of ExerciseRepository.prototype.formatDataForSharkFins:
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
