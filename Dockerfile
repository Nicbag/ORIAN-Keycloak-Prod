# Usar la imagen oficial de Keycloak como base
FROM quay.io/keycloak/keycloak:25.0.1

# Configurar entorno
ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
ENV KC_FEATURES=scripts
ENV KC_HTTP_PORT=9080
ENV KC_HTTPS_PORT=9443
ENV KC_HEALTH_ENABLED=true
ENV KC_HTTP_MANAGEMENT_PORT=9990

# Configuraciones para Mailgun
ENV JAVA_OPTS="-Djboss.mail.smtp.host=smtp.mailgun.org \
               -Djboss.mail.smtp.port=587 \
               -Djboss.mail.smtp.starttls.enable=true \
               -Djboss.mail.smtp.auth=true"

# Crear directorio de trabajo
WORKDIR /opt/keycloak

# Copiar la configuración del realm y el script de health check
COPY realm-config /opt/keycloak/data/import/
COPY realm-config/keycloak-health-check.sh /opt/keycloak/health-check.sh
COPY keycloak-db /opt/jboss/keycloak/standalone/data

# Dar permisos al script de health check
RUN chmod +x /opt/keycloak/health-check.sh

# Exponer los puertos que usa la aplicación
EXPOSE 9080 9443 9990

# Configurar el health check
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=40 \
  CMD bash /opt/keycloak/health-check.sh || exit 1

# Comando de inicio
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--import-realm"]
