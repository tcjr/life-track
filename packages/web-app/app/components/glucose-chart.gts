import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { Chart, registerables } from 'chart.js';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';

Chart.register(...registerables);

type PartialGlucoseMeasurement = Pick<
  GlucoseMeasurement,
  'value' | 'timestamp'
>;

interface GlucoseChartSignature {
  Args: {
    glucoses: PartialGlucoseMeasurement[];
  };
}

export default class GlucoseChart extends Component<GlucoseChartSignature> {
  chartModifier = modifier(
    (element: HTMLCanvasElement, [glucoses]: [PartialGlucoseMeasurement[]]) => {
      const data = glucoses.map((g) => ({
        x: new Date(g.timestamp).getTime(),
        y: g.value,
      }));

      // Sort data by time
      data.sort((a, b) => a.x - b.x);

      const chart = new Chart(element, {
        type: 'scatter',
        data: {
          datasets: [
            {
              label: 'Glucose',
              data: data,
              backgroundColor: 'rgb(255, 99, 132)',
              borderColor: 'rgb(255, 99, 132)',
              showLine: true,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            x: {
              type: 'linear',
              position: 'bottom',
              ticks: {
                callback: function (value) {
                  return new Date(value as number).toLocaleString();
                },
              },
            },
            y: {
              beginAtZero: false,
              title: {
                display: true,
                text: 'mg/dL',
              },
            },
          },
        },
      });

      return () => {
        chart.destroy();
      };
    }
  );

  <template>
    <div class="w-full h-64 mb-8">
      <canvas {{this.chartModifier @glucoses}}></canvas>
    </div>
  </template>
}
