import manifest from "../bootcamp/manifests/dev/manifest.json";
import { createDojoConfig } from "@dojoengine/core";

export const dojoConfig = createDojoConfig({
    manifest,
    rpcUrl: "/api" // Use proxy endpoint for rpcUrl
  });