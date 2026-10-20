import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";

export default function (pi: ExtensionAPI) {
  pi.on("agent_settled", async (event) => {
    // Notify on completion as well as on abort, so the user notices.
    // `event.aborted` is true when stopped with Escape etc.
    await new Promise<void>((resolve) => {
      execFile("bell-notify", (err) => {
        if (err) {
          console.error(`[notify] bell-notify failed: ${err.message}`);
        }
        resolve();
      });
    });
  });
}
