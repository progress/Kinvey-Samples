///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

class BaseController {
    constructor($scope, $injector) {
        this.$scope = $scope;
        this.$dataProviderService = $injector.get('providerService');
        this.$dsService = $injector.get('dsService');

        this.$ds = new kendo.data.DataSource({

            transport: this.$dataProviderService.getTransport('DataProvider1', {
                "create": function(options) {
                    options.success([]);
                },
                "destroy": function(options) {
                    options.success([]);
                },
                "read": function(options) {
                    options.success([]);
                },
                "update": function(options) {
                    options.success([]);
                }
            }),

            schema: {
                "model": {
                    "id": "Id",
                    "fields": {
                        "_id": {
                            "type": "string"
                        },
                        "Name": {
                            "type": "string"
                        },
                        "Contact": {
                            "type": "string"
                        },
                        "SalesRep": {
                            "type": "string"
                        },
                        "Phone": {
                            "type": "string"
                        }
                    }
                }
            },

            pageSize: 20,

        });
        this.$ds.bind('error', this._$errorHandler.bind(this));

        this.$model = {
            title: 'Customer',
            options: {
                pageable: {
                    pageSize: 20,
                    refresh: true
                },

                editable: 'readonly',
                selectable: true,
                filterable: false,
                groupable: false,
                resizable: false,
                reorderable: false,
                sortable: false,
                columns: [{
                        "encoded": true,
                        "field": "_id",
                        "filterable": true,
                        "sortable": true,
                        "title": "Id"
                    },
                    {
                        "encoded": true,
                        "field": "Name",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "Name"
                    },
                    {
                        "encoded": true,
                        "field": "Contact",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "Contact"
                    },
                    {
                        "encoded": true,
                        "field": "SalesRep",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "SalesRep"
                    },
                    {
                        "encoded": true,
                        "field": "Phone",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "Phone"
                    }
                ],
                dataSource: this.$ds
            },
            customSections: {
                top: 'views.customer.customer.topSection.html',
                middle: 'views.customer.customer.middleSection.html',
                bottom: 'views.customer.customer.bottomSection.html'
            },
            events: {
                onRowSelect: (e) => {

                    this['onRowSelect'](e);

                },
                onRowCreate: (e) => {

                },
                onRowUpdate: (e) => {

                },
                onRowDelete: (e) => {

                }
            }
        };
    }

    $onInit() {
        this.$scope.$on('$includeContentLoaded', () => {
            if (this.includeContentLoaded) {
                this.includeContentLoaded();
            }
        });

        this.$scope.$on('$viewContentLoaded', (e) => {
            if (this['onShow']) {
                this['onShow'](e.currentScope);
            }
        });

        this.$scope.$on('$includeContentError', (e) => {
            if (this.includeContentError) {
                this.includeContentError();
            }
        });

        this.$scope.$on('$destroy', this._$destroy.bind(this));
    }

    _$errorHandler(e) {
        const message = this.$dsService.extractErrorMessage(e);

        this.$scope.$emit('notification', {
            type: 'error',
            message: message
        });
    }

    _$destroy() {
        this.$ds.unbind('error', this._$errorHandler);

    }
}

export default BaseController