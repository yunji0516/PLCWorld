import {expect,it} from 'vitest'
import {deviceDisplayName,equipmentPartName} from './deviceDisplayName'
it('preserves released English device labels and exposes useful composite part names',()=>{
 expect(deviceDisplayName('Upper frame column -0.6')).toBe('Upper frame column -0.6')
 expect(deviceDisplayName('PART_SENSOR')).toBe('PART SENSOR')
 expect(equipmentPartName('receiver-support-column')).toBe('Receiving Support column')
 expect(equipmentPartName('motor-drive-housing')).toBe('Drive motor')
})
