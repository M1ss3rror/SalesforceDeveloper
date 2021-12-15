import { LightningElement, api } from 'lwc';
//Importar Clase "CreatePartidaController.cls"
import SearchProduct from '@salesforce/apex/CreatePartidaController.SearchProduct'
import Save from '@salesforce/apex/CreatePartidaController.Save'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
const columnas = [
    { label: 'Nombre', fieldName: 'productName' },
    { label: 'Valor Unidad', fieldName: 'unitPrice', type: 'currency' },
    { label: 'Cantidad', fieldName: 'quantity', editable: true, type: 'number' },
    { label: 'Disponible', fieldName: 'available' },
];

let CantidadTable = 0;

export default class PartidaPresupuestoLWC extends LightningElement {

    isPopUpActivo = false;
    isTablaLlena = false;
    Busqueda = '';
    Busqueda = [];
    columnas = columnas;
    @api recordId;

    AgregarPartida_Click() {
        // to open modal set isModalOpen tarck value as true
        this.isPopUpActivo = true;
    }

    CerrarPopUp() {
        // to close modal set isModalOpen tarck value as false
        this.isPopUpActivo = false;
        this.Limpiar();
    }

    Limpiar() {
        this.Busqueda = [];
        this.Busqueda = '';
        this.isTablaLlena = false;
    }

    CambioCodigo(event) {
        this.Busqueda = event.detail.value;
        console.log('Texto Busqueda -->' + this.Busqueda);
    }

    BuscarClick(event) {
        if (this.Busqueda === '') {
            this.showToast('Error de búsqueda', 'Ingrese un código de producto', 'error');
            this.Limpiar();
            return;
        }
        console.log('aloooo' + this.Busqueda);
        SearchProduct({ searchText: this.Busqueda })
            .then((result) => {
                if (result == '') {
                    this.showToast('Error de búsqueda', 'No existe un producto con el código especificado', 'error');
                    return;
                }
                this.Busqueda = result;
                this.isTablaLlena = true;
                //console.log('Resultado --> ' + JSON.stringify(this.Busqueda));
            })
            .catch((error) => {
                console.log('Este es el error' + error);
                this.Busqueda = '';
                this.showToast('Error de búsqueda', 'No existe un producto con el código especificado', 'error');
            });
    }

    LimpiarTabla(event) {
        this.Limpiar();
    }

    CambioCelda(event) {
        var Temporal = JSON.parse(JSON.stringify(this.Busqueda));
        CantidadTable = event.detail.draftValues[0].quantity;
        Temporal[0].quantity = event.detail.draftValues[0].quantity;
        this.Busqueda = JSON.parse(JSON.stringify(Temporal));
        //console.log('Este es el cambio -->' + JSON.stringify(this.Busqueda));
    }

    BotonGuardar(event) {

        var Temp = JSON.parse(JSON.stringify(this.Busqueda));
        var v = parseInt(CantidadTable);
        if (v == 0) {
            this.showToast('Error de cantidad', 'Ingrese un valor diferente de cero.', 'error');
            return;
        } else if (v > Temp[0].available) {
            this.showToast('Error de cantidad', 'La cantidad solicitada debe ser menor o igual a la cantidad disponible.', 'error');
            return;
        }
        Temp[0].quoteId = this.recordId;
        this.Busqueda = JSON.parse(JSON.stringify(Temp));
        Save({ partida: this.Busqueda[0] })
            .then((result) => {
                //console.log('Este es el resultado: ' + JSON.stringify(result));
                this.showToast('Partida guardada éxitosamente', '', 'success');
                this.isPopUpActivo = false;
                this.Limpiar();
            }).catch((error) => {
                console.log('Error: ' + JSON.stringify(error));
            });
    }

    showToast(titulo, contenido, tipo) {
        const event = new ShowToastEvent({
            title: titulo,
            message: contenido,
            variant: tipo
        });
        this.dispatchEvent(event);
    }
}