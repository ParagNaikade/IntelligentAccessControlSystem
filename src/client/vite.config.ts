import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  build: {
    sourcemap: false, // default is false, but you can ensure it's off
  },
  server: {
    port: 3000,
  },
});
