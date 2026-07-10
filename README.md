# iGnite — Flutter UI Mockup

Improved UI mockup for the **MeDREV IGNITE Smart Recovery Platform** — an intelligent
full-body therapy system delivering automated **heat + vibration therapy** through up to
**4 interchangeable body wraps** in a single therapy cycle.

Built as a high-fidelity interactive mockup (no real BLE/backend — everything is
simulated with mock data and timers).

## Screens & Flow

Follows the user journey from the April 2026 progress report, redesigned:

1. **Welcome** — brand intro + key features
2. **Sign Up / Sign In / Forgot Password** — clean auth forms with loading states
3. **Dashboard** — greeting, device status, Start Therapy hero, today's stats, weekly chart, recent sessions
4. **Device** — BLE pairing flow (scan → found → connect) with pulse animation, connected view showing battery/signal/safety + 4 wrap ports
5. **Choose Treatment** — Sport vs Medical therapy modes, preset programs + custom session
6. **Session Setup** — per-wrap config (body area, 35–45°C heat slider, vibration level), up to 4 wraps, duration, safety notice, battery estimate
7. **Session Running** — dark focus mode with animated circular countdown, live per-wrap temperature tiles (simulated ramp-up + sensor jitter), pause/resume/stop with confirm
8. **Session Complete** — summary stats + patient feedback prompt
9. **History** — weekly summary + sessions grouped by day
10. **Profile** — user details, preferences, device & safety info, sign out

## Design system ("Ember")

- **Primary:** ember orange-red `#F04E23` (heat/brand) · **Secondary:** medical teal `#0E9DA4`
- Clinical neutrals, 20px card radius, Figtree typeface (Google Fonts)
- Heat ramp colours (amber → deep red) tied to temperature values
- Material 3, light theme + dark "focus mode" for live sessions

## Run

```bash
flutter pub get
flutter run            # pick a device (Android emulator / iOS simulator / chrome)
```

Demo tip: sign in with anything (mock auth), pair the device from the **Device** tab
first, then start a therapy from the dashboard. Set duration to 10 min and hit Stop
early to see the completion flow quickly.
