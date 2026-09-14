hacerClic = document.getElementById("contenedor");
hacerClic.addEventListener('click', function (event){
    id = event.target.getAttribute("id");
    if (id === "submit-contac") {
        validarContac();
    }
});

function validarContac(){
    nombres = document.getElementById('nombres').value;
    email = document.getElementById('email').value;
    edad = document.getElementById('edad').value;
    mensaje = document.getElementById('mensaje').value;

    if (nombres === "") {
        alert("El campo nombres no puede estar vacío.");
    }
    else if (email === "") {
        alert("El campo email no puede estar vacío.");
    }
    else if (edad === "") {
        alert("El campo edad no puede estar vacío.");
    }
    else if (mensaje === "") {
        alert("El campo mensaje no puede estar vacío.");
    }
    else {
        event.preventDefault();
        alert("Sus datos han sido enviados correctamente!");
        document.formContact.submit();
    }
}