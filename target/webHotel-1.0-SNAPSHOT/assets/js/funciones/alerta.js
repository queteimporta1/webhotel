function fnToastr(tipo, msj) {
    if (tipo === 'success') {
        Swal.fire(
                '¡Éxito!',
                `${msj}`,
                'success'
                );
    } else if (tipo === 'error') {
        Swal.fire(
                '¡Error!',
                `${msj}`,
                'error'
                );
    } else if (tipo === 'info') {
        Swal.fire(
                '¡Info!',
                `${msj}`,
                'info'
                );
    }
}