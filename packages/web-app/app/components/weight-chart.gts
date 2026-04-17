import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { Chart, registerables } from 'chart.js';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import { getRuntimeCssVar } from '#app/utils/browser.ts';
import { asLocal, asYYYYMMDD } from '#app/utils/dates.ts';

Chart.register(...registerables);

type PartialWeightMeasurement = Pick<
  WeightMeasurement,
  'value' | 'timestamp'
>;

interface WeightChartSignature {
  Args: {
    weights: PartialWeightMeasurement[];
  };
}

export default class WeightChart extends Component<WeightChartSignature> {
  chartModifier = modifier(
    (element: HTMLCanvasElement, [weights]: [PartialWeightMeasurement[]]) => {
      const data = weights.map((w: PartialWeightMeasurement) => ({
        x: new Date(w.timestamp as Date | string | number).getTime(),
        y: w.value,
      }));

      // Sort data by time
      data.sort((a, b) => a.x - b.x);

      const color = getRuntimeCssVar('--color-primary');

      const chart = new Chart(element, {
        type: 'scatter',
        data: {
          datasets: [
            {
              label: 'Weight',
              data: data,
              backgroundColor: color,
              borderColor: color,
              showLine: true, // Connect the dots for weight trends
            },
          ],
        },
        options: {
          plugins: {
            tooltip: {
              callbacks: {
                label: function (context) {
                  const d = new Date(context.parsed.x as number);
                  const v = context.parsed.y;
                  const tipContent = `${asLocal(d)}: ${v}lbs`;
                  return tipContent;
                },
              },
            },
          },

          responsive: true,
          maintainAspectRatio: false,
          scales: {
            x: {
              type: 'linear',
              position: 'bottom',
              ticks: {
                callback: function (value) {
                  return asYYYYMMDD(new Date(value as number));
                },
              },
            },
            y: {
              beginAtZero: false,
              title: {
                display: true,
                text: 'lbs',
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
      <canvas {{this.chartModifier @weights}}></canvas>
    </div>
  </template>
}
