import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { Chart, registerables } from 'chart.js';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import { getRuntimeCssVar } from '#app/utils/browser.ts';
import { asLocal, asYYYYMMDD } from '#app/utils/dates.ts';

Chart.register(...registerables);

type PartialBpMeasurement = Pick<
  BpMeasurement,
  'systolic' | 'diastolic' | 'timestamp'
>;

interface BpChartSignature {
  Args: {
    bps: PartialBpMeasurement[];
  };
}

export default class BpChart extends Component<BpChartSignature> {
  chartModifier = modifier(
    (element: HTMLCanvasElement, [bps]: [PartialBpMeasurement[]]) => {
      const systolicData = bps.map((b) => ({
        x: new Date(b.timestamp).getTime(),
        y: b.systolic,
      }));

      const diastolicData = bps.map((b) => ({
        x: new Date(b.timestamp).getTime(),
        y: b.diastolic,
      }));

      // Sort data by time
      systolicData.sort((a, b) => a.x - b.x);
      diastolicData.sort((a, b) => a.x - b.x);

      const systolicColor = getRuntimeCssVar('--color-primary');
      const diastolicColor = getRuntimeCssVar('--color-secondary');

      const chart = new Chart(element, {
        type: 'scatter',
        data: {
          datasets: [
            {
              label: 'Systolic',
              data: systolicData,
              backgroundColor: systolicColor,
              borderColor: systolicColor,
              showLine: false,
            },
            {
              label: 'Diastolic',
              data: diastolicData,
              backgroundColor: diastolicColor,
              borderColor: diastolicColor,
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
                  const label = context.dataset.label;
                  const tipContent = `${asLocal(d)}: ${label} ${v}mmHg`;
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
                text: 'mmHg',
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
      <canvas {{this.chartModifier @bps}}></canvas>
    </div>
  </template>
}
