import streamlit as st
import pandas as pd
import pyodbc

# 1. Configuración de Conexión (Cambien estos datos por los de su Ubuntu/Docker)
DSN = 'CrediCoreDSN'
USERNAME = 'AdminCrediCore'
PASSWORD = 'Password_Credi2026!'

conn_str = f'DSN={DSN};UID={USERNAME};PWD={PASSWORD};'

st.set_page_config(page_title="ERP CrediCore", layout="centered")
st.title("🏦 CrediCore - Módulo de Caja")
st.markdown("Interfaz conectada directamente al motor transaccional de SQL Server")

# 2. Leer la Vista Segura
st.subheader("Estado de Cuenta (Vista Segura)")
try:
    conn = pyodbc.connect(conn_str)
    # Llamamos a la vista, no a las tablas
    query = "SELECT * FROM VW_AtencionAlCliente"
    df = pd.read_sql(query, conn)
    st.dataframe(df, use_container_width=True)
except Exception as e:
    st.error(f"Error de conexión a la BD: {e}")

st.divider()

# 3. Formulario para ejecutar el Procedimiento Almacenado
st.subheader("Procesar Pago de Cuota")
with st.form("form_pago", clear_on_submit=True):
    id_credito = st.number_input("Número de Crédito (ID)", min_value=1, step=1)
    monto_pago = st.number_input("Monto a Abonar (Q)", min_value=1.0, step=100.0)
    btn_pagar = st.form_submit_button("Ejecutar Transacción")
    
    if btn_pagar:
        try:
            cursor = conn.cursor()
            # Invocamos el SP con sus parámetros
            cursor.execute(f"EXEC SP_ProcesarPago @IdCredito = {id_credito}, @MontoAbono = {monto_pago}")
            cursor.commit()
            st.success("¡Pago procesado con éxito en SQL Server!")
            st.rerun() # Recarga la pantalla para actualizar la tabla
        except Exception as e:
            # Aquí capturamos el RAISERROR que ustedes programaron en el TRY...CATCH de SQL
            st.error(f"Transacción Rechazada por el Motor: {e}")