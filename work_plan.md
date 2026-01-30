## 0. Preparation (0.5h)
- **Set up version control** (e.g., GitHub repo).
- **Install Godot** and ensure all team members have access.
- **Create a shared asset folder** for art and placeholder assets.

---

## 1. Core Game Loop & Prototyping (2h)
- **Create a new Godot project.**
- **Design a basic level layout** (simple rooms, corridors).
- **Implement player movement** (top-down or side view).
- **Add placeholder sprites** for player, guards, nurses, and doors.

---

## 2. Enemy AI & Vision Cone (3h)
- **Implement basic enemy patrols** (guards/nurses follow paths).
- **Add vision cone (FOV) logic** for enemies:
  - Visualize cone for debugging.
  - Detect player within cone.
- **Set up enemy alert states** (idle, suspicious, hostile).

---

## 3. Face Mechanics (2h)
- **Implement face stealing mechanic:**
  - Player can "kill" and take face from guard/nurse.
  - Track which face is currently worn.
- **Restrict access to areas** based on current face.
- **Change enemy behavior** based on player’s face.

---

## 4. Face Deformation & Suspicion (2h)
- **Implement face timer:** Face deforms over time.
- **Increase enemy suspicion** as face deforms:
  - Expand vision cone.
  - Change enemy alertness.
- **Visual feedback** for face deformation (UI or sprite change).

---

## 5. Main Doctor & Endgame (2h)
- **Design main doctor character** with unique face.
- **Restrict access to final area** until doctor’s face is stolen.
- **Implement final escape sequence:**
  - All enemies become hostile once player has their own face.

---

## 6. Art & Polish (4h, parallel with coding)
- **Artist creates key sprites:** Player, guards, nurses, doctor, faces, UI elements.
- **Create simple tileset** for clinic environment.
- **Add basic animations** (walking, face stealing, alert states).
- **Implement placeholder sounds** (optional).

---

## 7. UI & Feedback (2h)
- **Add HUD:** Show current face, deformation timer, suspicion level.
- **Add simple menus:** Start, restart, win/lose screens.
- **Visual cues:** Alert icons, vision cone visualization, face deformation effects.

---

## 8. Level Design & Balancing (2h)
- **Design at least one complete level** with:
  - Multiple guards/nurses.
  - Restricted areas.
  - Doctor’s office.
  - Escape route.
- **Playtest and adjust** patrols, vision cones, face timers for fun and challenge.

---

## 9. Bugfixing & Final Polish (2.5h)
- **Fix critical bugs.**
- **Polish transitions and feedback.**
- **Ensure game can be completed from start to finish.**
- **Prepare build for submission/demo.**

---

### Tips for Efficiency
- Use placeholder art and sounds early; replace with final assets as they’re ready.
- Prioritize core mechanics first; add polish and extra features only if time allows.
- Communicate frequently; coders and artist should sync on asset needs and progress.

---

**Summary Table:**

| Phase                        | Time (h) | Who         |
|------------------------------|----------|-------------|
| Preparation                  | 0.5      | All         |
| Core Game Loop & Prototyping | 2        | Coders      |
| Enemy AI & Vision Cone       | 3        | Coders      |
| Face Mechanics               | 2        | Coders      |
| Face Deformation & Suspicion | 2        | Coders      |
| Main Doctor & Endgame        | 2        | Coders      |
| Art & Polish                 | 4        | Artist      |
| UI & Feedback                | 2        | Coders      |
| Level Design & Balancing     | 2        | All         |
| Bugfixing & Final Polish     | 2.5      | All         |

---

Let me know if you want this broken down into even more granular tasks or need a Trello/Notion-style checklist!

# User (5960ba97-8c9c-4831-b44f-fd2c5ddde09f) ───

##neovim://selection


yes i want a more detailed example for each think about first person maze with enemy sprites. kind of like early doom or wolfenstein but different art style

# Copilot (8204e21a-6d15-47cc-b30c-429ef5a41fec) ───

Absolutely! Here’s a detailed, step-by-step plan tailored for a **first-person maze game** with enemy sprites (like early Doom/Wolfenstein), using Godot, for a 20-hour hackathon with 2 coders and 1 artist. Each step is broken down into actionable tasks.

---

## 0. Preparation (0.5h)
- **Set up Git repository** and Godot project.
- **Agree on art style and scope** (simple, readable sprites and textures).
- **Share placeholder assets folder** for quick iteration.

---

## 1. Core First-Person Controller & Maze (2h)
- **Implement basic first-person movement:**
  - WASD for movement, mouse for looking.
  - Clamp vertical look to avoid flipping.
- **Create a simple maze level:**
  - Use grid-based layout for fast prototyping.
  - Place walls, doors, and key locations (start, doctor’s office, escape).
- **Add collision detection** for walls.

---

## 2. Rendering & Enemy Sprites (2h)
- **Set up first-person camera.**
- **Implement billboarded enemy sprites:**
  - Enemies always face the player.
  - Use placeholder art for now.
- **Add basic environment textures** (walls, floor, ceiling).

---

## 3. Enemy AI & Vision Cone (3h)
- **Implement enemy patrols:**
  - Enemies follow set paths or stand guard.
- **Add vision cone logic:**
  - Calculate FOV cone in front of enemy.
  - Visualize cone for debugging (optional).
  - Detect player if inside cone and not disguised.
- **Set up enemy alert states:**
  - Idle, suspicious (player in cone but disguised), hostile (player detected).

---

## 4. Face Stealing & Disguise System (2h)
- **Implement face stealing:**
  - Player can "attack" enemy from behind to steal face.
  - Track which face is worn.
- **Restrict access to areas** based on current disguise.
- **Change enemy behavior** based on disguise (hostile or neutral).

---

## 5. Face Deformation & Suspicion (2h)
- **Add timer for face deformation:**
  - Face deforms over time after being stolen.
- **Increase suspicion as face deforms:**
  - Enemies’ vision cones expand.
  - Alertness increases.
- **Visual feedback:**
  - UI indicator for face condition.
  - Optional: change hand/face sprite in HUD.

---

## 6. Main Doctor & Endgame (2h)
- **Create main doctor enemy:**
  - Unique patrol or stationary in locked office.
- **Restrict access to final area** (needs doctor’s face).
- **Implement escape sequence:**
  - Once player has their own face, all enemies become hostile.
  - Mark escape route on map.

---

## 7. Art Production (4h, parallel)
- **Artist creates:**
  - Enemy sprites (front, side, back if possible).
  - Player hand/weapon sprite.
  - Wall/floor/ceiling textures.
  - UI elements (face icon, timer, suspicion meter).
  - Doctor and player face sprites.
- **Integrate assets** as they’re ready.

---

## 8. UI & Feedback (2h)
- **Add HUD:**
  - Current face/disguise.
  - Deformation timer.
  - Suspicion/alert meter.
- **Menus:**
  - Start, pause, win/lose screens.
- **Visual/audio cues:**
  - Enemy alert sounds.
  - Face deformation effects.

---

## 9. Level Design & Playtesting (2h)
- **Design at least one full maze:**
  - Place enemies, locked doors, doctor’s office, escape.
- **Playtest for balance:**
  - Adjust patrols, vision cones, face timers.
- **Iterate on level layout for fun and challenge.**

---

## 10. Bugfixing & Polish (2.5h)
- **Fix critical bugs.**
- **Polish transitions, feedback, and art integration.**
- **Ensure game is completable and fun.**
- **Prepare build for submission/demo.**

---

### Example Task Breakdown for "Enemy AI & Vision Cone"
1. **Create enemy scene with patrol logic.**
2. **Add vision cone calculation:**
   - Use angle and distance from enemy forward direction.
   - Cast ray to check for wall obstructions.
3. **Detect player in cone:**
   - If player is not disguised, trigger hostile state.
   - If disguised but face is deformed, increase suspicion.
4. **Debug:**
   - Draw vision cone in editor for testing.
   - Log detection events.

---

### Example Task Breakdown for "Face Stealing & Disguise"
1. **Allow player to approach enemy from behind.**
2. **On input, trigger face steal:**
   - Remove enemy from scene.
   - Assign enemy’s face to player.
   - Reset face deformation timer.
3. **Update HUD to show new disguise.**
4. **Change enemy reactions based on disguise.**

---

### Example Task Breakdown for "Face Deformation & Suspicion"
1. **Start timer when new face is stolen.**
2. **Gradually increase suspicion meter as timer runs.**
3. **Expand enemy vision cones as suspicion increases.**
4. **Update HUD and visual feedback.**

---

Let me know if you want a Trello-style checklist or a more granular breakdown for any specific phase!

# User (2d433822-489f-4bd6-b10f-36270b1b1d99) ───

##neovim://selection


can you make a development plan for 2 coders and artist so they can work on things at the same time but on different things. how woudl the work be divided

# Copilot (d34b809f-189d-4044-aa79-331100c26f1b) ───

Certainly! Here’s a parallelized development plan for a 20-hour hackathon, maximizing productivity for **2 coders and 1 artist**. Tasks are divided so each person can work independently, with clear dependencies and handoff points.

---

## **Phase 0: Setup (All, 0.5h)**
- Set up Git repo, Godot project, and shared asset folder.
- Agree on art style, scope, and communication tools.

---

## **Phase 1: Core Systems (2h, Parallel)**

**Coder 1:**
- Implement first-person controller (movement, camera).
- Set up basic maze level with collisions.

**Coder 2:**
- Create enemy scene with patrol logic.
- Prototype vision cone/FOV logic (debug visualization).

**Artist:**
- Sketch placeholder sprites for player hand, enemy, and basic wall/floor textures.

---

## **Phase 2: Game Mechanics (3h, Parallel)**

**Coder 1:**
- Implement face stealing mechanic (from behind).
- Set up disguise system (track current face).

**Coder 2:**
- Expand enemy AI: alert states, detection based on disguise.
- Add suspicion system (vision cone expands as face deforms).

**Artist:**
- Create final sprites for enemies (front, side, back if possible).
- Design player hand/weapon sprite.
- Make basic UI elements (face icon, timer, suspicion meter).

---

## **Phase 3: Level & Systems Integration (3h, Parallel)**

**Coder 1:**
- Integrate artist’s sprites and textures into the game.
- Implement area restrictions based on disguise.

**Coder 2:**
- Add main doctor character and logic for final area access.
- Implement escape sequence (all enemies hostile after reclaiming face).

**Artist:**
- Create doctor sprite and unique face assets.
- Polish wall/floor/ceiling textures.
- Add environmental props (doors, signs).

---

## **Phase 4: UI, Feedback, and Polish (3h, Parallel)**

**Coder 1:**
- Implement HUD (face, timer, suspicion meter).
- Add menus (start, pause, win/lose).

**Coder 2:**
- Add visual/audio cues for enemy alert, face deformation.
- Polish transitions and feedback.

**Artist:**
- Refine UI elements.
- Create simple animations (enemy alert, face steal).
- Add effects for face deformation (sprite changes, overlays).

---

## **Phase 5: Level Design & Playtesting (3h, Parallel)**

**Coder 1:**
- Design and implement at least one full maze level.
- Place enemies, locked doors, doctor’s office, escape route.

**Coder 2:**
- Playtest and balance patrols, vision cones, face timers.
- Fix bugs and polish gameplay.

**Artist:**
- Polish and finalize all art assets.
- Assist with level dressing (props, signage).

---

## **Phase 6: Final Polish & Submission (2.5h, All)**
- Integrate all assets and code.
- Final playtesting and bugfixing.
- Prepare build for submission/demo.

---

### **Summary Table**

| Phase         | Coder 1                        | Coder 2                        | Artist                        |
|---------------|-------------------------------|-------------------------------|-------------------------------|
| Setup         | Project setup                 | Project setup                 | Project setup                 |
| Core Systems  | Player controller, maze       | Enemy AI, vision cone         | Placeholder sprites/textures  |
| Mechanics     | Face stealing, disguise       | AI alert/suspicion, FOV logic | Final sprites, UI elements    |
| Integration   | Art integration, area locks   | Doctor, escape logic          | Doctor, props, textures       |
| UI/Polish     | HUD, menus                    | Audio/visual cues, feedback   | UI, animations, effects       |
| Level/Testing | Level design, implementation  | Playtest, balance, bugfix     | Art polish, level dressing    |
| Final Polish  | Integration, bugfix           | Integration, bugfix           | Integration, bugfix           |

---

**Tips:**
- Coders should regularly merge and test each other’s work.
- Artist should provide placeholder assets early, then replace with finals.
- Use version control branches for major features to avoid conflicts.
- Communicate dependencies (e.g., when new art is ready for integration).

Let me know if you want a Trello-style board or more granular task breakdowns!
