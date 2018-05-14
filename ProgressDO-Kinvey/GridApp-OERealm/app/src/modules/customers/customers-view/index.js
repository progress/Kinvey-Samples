///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

import angular from 'angular';

import BaseController from './controller';
import Controller from './controller.public';
import routerEvents from './router-events';
import './style.css';

import bottomSection from './bottomSection.html';
import middleSection from './middleSection.html';
import topSection from './topSection.html';

export default angular.module('views.customers.customers-view', [])
    .controller('CustomersCustomersViewCtrl', Controller)
    .factory('customersCustomersView', routerEvents)
    .run(['$templateCache', ($templateCache) => {
        $templateCache.put('views.customers.customers-view.bottomSection.html', bottomSection);
        $templateCache.put('views.customers.customers-view.middleSection.html', middleSection);
        $templateCache.put('views.customers.customers-view.topSection.html', topSection);
    }])
    .name;