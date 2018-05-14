///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

import angular from 'angular';

import BaseController from './controller';
import Controller from './controller.public';
import routerEvents from './router-events';

import bottomSection from './bottomSection.html';
import middleSection from './middleSection.html';
import topSection from './topSection.html';

export default angular.module('views.customer.customer', [])
    .controller('CustomerCustomerCtrl', Controller)
    .factory('customerCustomer', routerEvents)
    .run(['$templateCache', ($templateCache) => {
        $templateCache.put('views.customer.customer.bottomSection.html', bottomSection);
        $templateCache.put('views.customer.customer.middleSection.html', middleSection);
        $templateCache.put('views.customer.customer.topSection.html', topSection);
    }])
    .name;