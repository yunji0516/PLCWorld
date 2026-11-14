import type { Config } from 'tailwindcss'

/**
 * Control-panel HMI theme. CSS variables in globals.css are the source of truth.
 */
const config: Config = {
  darkMode: ['class', '[data-theme="dark"]'],
  content: ['./app/**/*.{ts,tsx}', './components/**/*.{ts,tsx}', './lib/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        canvas: 'var(--canvas)',
        surface: {
          DEFAULT: 'var(--surface)',
          sunken: 'var(--surface-sunken)',
          raised: 'var(--surface-raised)',
          hover: 'var(--surface-hover)',
        },
        line: { DEFAULT: 'var(--line)', strong: 'var(--line-strong)' },
        text: {
          DEFAULT: 'var(--text)',
          muted: 'var(--text-muted)',
          subtle: 'var(--text-subtle)',
        },
        // Signal colors match control-panel indicators.
        live: 'var(--live)', // Energized (TRUE)
        idle: 'var(--idle)', // De-energized (FALSE)
        run: 'var(--run)',
        warn: 'var(--warn)',
        fault: 'var(--fault)',
        accent: 'var(--accent)',
      },
      fontFamily: { sans: ['var(--font-sans)'], mono: ['var(--font-mono)'] },
      fontSize: {
        '2xs': ['0.6875rem', { lineHeight: '1rem' }],
        xs: ['0.75rem', { lineHeight: '1.125rem' }],
        sm: ['0.8125rem', { lineHeight: '1.25rem' }],
        base: ['0.875rem', { lineHeight: '1.375rem' }],
      },
      borderRadius: { DEFAULT: '0.375rem', md: '0.375rem', lg: '0.5rem', xl: '0.75rem' },
      transitionDuration: { fast: '120ms', DEFAULT: '180ms' },
    },
  },
  plugins: [],
}

export default config
