import { defineConfig } from "vite";
import wasm from "vite-plugin-wasm";
import react from "@vitejs/plugin-react";
import topLevelAwait from "vite-plugin-top-level-await";

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [react(), wasm(), topLevelAwait()],
    server:{
    proxy: {
        '/api': {
            target: 'http://localhost:5050',
            changeOrigin: true,
            rewrite: (path) => path.replace(/^\/api/, '')
        }
        }     
    }
});
