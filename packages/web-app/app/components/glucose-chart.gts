import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { Chart, registerables } from 'chart.js';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import { getRuntimeCssVar } from '#app/utils/browser.ts';
import { asLocal, asYYYYMMDD } from '#app/utils/dates.ts';

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

      const color = getRuntimeCssVar('--color-primary');
      console.log('color', color);

      const chart = new Chart(element, {
        type: 'scatter',
        data: {
          datasets: [
            {
              label: 'Glucose',
              data: data,
              backgroundColor: color,
              borderColor: color,
              showLine: false,
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
                  const tipContent = `${asLocal(d)}: ${v}mg/dL}`;
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
