import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type Owner from '@ember/owner';
import type FirebaseService from '#app/services/firebase.ts';
import { service } from '@ember/service';
import { collections } from '#app/models/collections.ts';
import type MeasurementDataService from '#app/services/measurement-data.ts';

export interface MeasurementsSignature {
  Args: { model: unknown };
  Element: HTMLDivElement;
}

export default class Measurements extends Component<MeasurementsSignature> {
  @service declare firebase: FirebaseService;
  @service declare measurementData: MeasurementDataService;

  constructor(owner: Owner, args: MeasurementsSignature['Args']) {
    super(owner, args);
    void this.loadBps();
    void this.loadGlucoses();
    void this.loadWeights();
  }

  get uid() {
    return this.firebase.uid;
  }

  // These loaders will populate the data service

  loadBps = async () => {
    const bps = await collections['app-users'](this.uid).bps.findMany({
      name: 'all-bps',
      limit: 2000,
    });
    this.measurementData.allMeasurements.bps = bps;
  };

  loadGlucoses = async () => {
    const glucoses = await collections['app-users'](this.uid).glucoses.findMany(
      {
        name: 'all-glucoses',
        limit: 2000,
      }
    );
    this.measurementData.allMeasurements.glucoses = glucoses;
  };

  loadWeights = async () => {
    const weights = await collections['app-users'](this.uid).weights.findMany(
      {
        name: 'all-weights',
        limit: 2000,
      }
    );
    this.measurementData.allMeasurements.weights = weights;
  };

  <template>
    {{pageTitle "Measurements"}}
    {{outlet}}
  </template>
}
