# elevator_model

Model and VHDL implementation of a four-floor elevator controller, done as a course project (advanced topics
in embedded systems). The behaviour was first described as a Petri net, then designed as a set of
communicating finite-state machines, and finally written in VHDL and simulated. The project report
(`Elevator_Report.pdf`, in Persian) walks through the models and the simulation waveform.

## What is in the repo

**VHDL (`VHDL/`)**

| File | Entity | Role |
|---|---|---|
| `Elevator.vhd` | `elevator` | Top level. A two-state machine (`revision_mode` / `normal_mode`): after `reset` the elevator is in revision (maintenance) mode, where the `man_*` inputs drive the motor, brake and door directly; `start_elevator` switches to normal mode, where the outputs come from the controller and cabin FSMs. Instantiates one `controller`, one `cabin` and four `BTN`s. |
| `controller.vhd` | `controller` | Central Moore FSM. Tracks the cabin position with the floor-entry sensors (`enter_F1_up` ... `enter_F4_down`), serves the floor requests `LB1`..`LB4`, and drives `move_up`, `move_down`, `brake`, `move_request` and the `at_F1`..`at_F4` outputs. |
| `Cabin.vhd` | `cabin` | Door FSM (`idle`, `pending_close`, `movingready`). On `move_request` it closes the door, reopens it if someone is `passing` or the `open_btn` is pressed, and raises `ready_to_move` once `door_closed` is seen; on `arrive` it opens the door again. |
| `Buttons.vhd` | `BTN` | Per-floor call light. Latches on when the inside (`ILB`) or outside (`OLB`) button is pressed and clears when the cabin is `at_floor`. |
| `Elvator_TB.vhd` | `elevator_tb` | Testbench. Resets, starts the elevator, requests floor 3 from inside, then feeds the floor sensors to walk the cabin to floor 3. |

**Models and figures**

- `*.graphml` - the diagrams, editable with yEd: `Eleveator_Petri_net.graphml` (Petri net of the whole
  system), `petri_net_btn1..4.graphml` (one Petri net per floor button), `top_FSM.graphml`,
  `Elevator_FSM.graphml` (controller), `cabin_fsm.graphml` and `BTN_FSM.graphml`.
- `Images(better_quality)/` - PNG exports of the diagrams and `wave.bmp`, the simulation waveform shown in
  the report.
- `Elevator_Report.pdf` - the written report.

## Simulating

No simulator project or script is included. Add the five files in `VHDL/` to a project in any VHDL simulator
(e.g. ModelSim/Questa or GHDL) and run the `elevator_tb` entity (architecture `bh`); the stimulus ends after
about 20 ns. The design only needs `ieee.std_logic_1164`.

Note that the FSMs are written as asynchronous processes (no clock) and use `after` delays in the cabin
process, so the model is meant for simulation rather than synthesis.
