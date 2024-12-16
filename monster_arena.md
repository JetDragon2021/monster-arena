# Monster Arena: Game Design Document

## Game Concept
Monster Arena is a real-time monster fighting game where players control a monster in a dynamic, movement-based arena combat system.

## Combat Mechanics
- **Real-Time Movement**
  - Free-form movement using WASD controls
  - Dodge and position strategically
  - No turn-based restrictions

## Monsters (6 Playable Characters)

### 1. Rockjaw
- **Type**: Defensive Bruiser
- **Special Ability**: Stone Skin
  - Temporarily increases physical resistance
  - Reduces incoming damage by 50%
  - Works as a personal defensive buff
  - Ideal for tanking damage in 1v1 combat

### 2. Shadowclaw
- **Type**: Assassin
- **Special Ability**: Stealth Strike
  - Temporary invisibility
  - Next attack guarantees critical hit
  - Increases movement speed during stealth
  - Allows for surprise attacks and repositioning

### 3. Stormbringer
- **Type**: Ranged Elemental
- **Special Ability**: Lightning Surge
  - Unleashes a chain lightning attack
  - Deals damage to primary target
  - Stuns target briefly
  - Creates zone control in 1v1 combat

### 4. Verdant
- **Type**: Self-Sustaining Fighter
- **Special Ability**: Regenerative Burst
  - Rapidly regenerates personal health
  - Creates a healing zone around self
  - Increases own attack speed temporarily
  - Focuses on self-preservation in combat

### 5. Inferno
- **Type**: Damage Over Time Specialist
- **Special Ability**: Molten Core
  - Increases personal attack damage
  - Applies burning effect to attacks
  - Creates a damaging aura around self
  - Punishes close-range combat

### 6. Frostbite
- **Type**: Control Fighter
- **Special Ability**: Absolute Zero
  - Slows down enemy movement
  - Freezes target momentarily
  - Creates ice barriers for personal protection
  - Disrupts enemy positioning

## Universal Abilities (12 Shared Abilities)

1. **Clone**
   - Creates a clone of the player
   - Clone has 1 health point
   - Distracts enemy
   - Allows for tactical positioning

2. **Personal Heal**
   - Restores a percentage of own health
   - No ally healing
   - Quick self-recovery mechanism

3. **Counter**
   - Reactive defensive ability
   - Triggers when successfully dodging an enemy attack
   - Instantly counterattacks the enemy
   - Deals high damage
   - Short window of opportunity
   - Encourages precise timing and skill

4. **Rage Mode**
   - Dramatically increases personal attack damage
   - Reduces own defense
   - High-risk, high-reward ability

5. **Personal Shield**
   - Creates a protective barrier
   - Absorbs a set amount of damage
   - Self-defense mechanism

6. **Poison Cloud**
   - Creates a damaging area around self
   - Damages enemies who enter the zone
   - Area control ability

7. **Teleport**
   - Instantly move to a new location
   - Escape dangerous situations
   - Surprise repositioning

8. **Life Drain**
   - Steal health from the enemy
   - Heal self based on damage dealt
   - Sustain through offensive actions

9. **Reflect**
   - Temporarily reflect incoming damage
   - Turn enemy attacks against them
   - Strategic defensive ability

10. **Berserk**
    - Massive damage boost
    - Reduced defense
    - High-risk offensive ability

11. **Time Warp**
    - Reset all personal ability cooldowns
    - Strategic reset button
    - Use in critical moments

12. **Spectral Shift**
    - Become temporarily invulnerable
    - Phase through attacks
    - Escape or reposition

## Battle Philosophy
- Emphasize player skill and movement
- Reward strategic ability usage
- Create dynamic, fast-paced combat
- Focus on individual monster strengths

## Design Principles
- Real-time, movement-based combat
- Unique monster abilities
- Strategic ability management
- Skill-based gameplay