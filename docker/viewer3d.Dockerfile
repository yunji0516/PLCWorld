FROM node:22-bookworm-slim

WORKDIR /artifact/viewer3d
COPY viewer3d/ ./
RUN npm ci

COPY replay/viewer/catalog.json /artifact/replay/viewer/catalog.json
COPY replay/viewer/provenance.json /artifact/replay/viewer/provenance.json
COPY replay/viewer/tasks/ /artifact/replay/viewer/tasks/
COPY replay/viewer/presentation/ /artifact/replay/viewer/presentation/
COPY replay/viewer/geometry/ /artifact/replay/viewer/geometry/
RUN npm run build

WORKDIR /artifact/viewer3d/apps/plc-simulator
EXPOSE 3200
CMD ["../../node_modules/.bin/next", "start", "-p", "3200", "-H", "0.0.0.0"]
