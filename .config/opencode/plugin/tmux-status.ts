import type { Plugin } from "@opencode-ai/plugin"

type WindowStatus = "running" | "waiting" | "stop" | "error" | "end"

const WINDOW_STATUS_SCRIPT = "/Users/michaelwelford/.config/tmux/window_status.sh"

export default (async ({ $ }) => {
  async function setStatus(status: WindowStatus) {
    try {
      await $`${WINDOW_STATUS_SCRIPT} ${status}`.quiet()
    } catch {
      // Status updates are best-effort and must never break opencode hooks.
    }
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.status") {
        if (event.properties.status.type === "busy") {
          await setStatus("running")
          return
        }

        if (event.properties.status.type === "idle") {
          await setStatus("stop")
          return
        }

        if (event.properties.status.type === "retry") {
          await setStatus("error")
          return
        }
      }

      if (event.type === "session.idle") {
        await setStatus("stop")
        return
      }

      if (event.type === "session.error") {
        await setStatus("error")
        return
      }
    },

    "chat.message": async () => {
      await setStatus("running")
    },

    "chat.params": async () => {
      await setStatus("running")
    },

    "command.execute.before": async () => {
      await setStatus("running")
    },

    "tool.execute.before": async () => {
      await setStatus("running")
    },

    "tool.execute.after": async () => {
      await setStatus("running")
    },

    "permission.ask": async () => {
      await setStatus("waiting")
    },
  }
}) satisfies Plugin
