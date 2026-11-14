import type { NextConfig } from 'next'
import path from 'path'

const nextConfig: NextConfig = {
  deploymentId: 'plcworld-artifact-viewer',
  outputFileTracingRoot: path.join(__dirname, '..', '..'),
  transpilePackages: ['three'],
}

export default nextConfig
