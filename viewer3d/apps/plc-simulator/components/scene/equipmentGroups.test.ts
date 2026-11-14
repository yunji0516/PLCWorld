import {expect,it} from 'vitest'
import {Group,Mesh,BoxGeometry,MeshStandardMaterial,Vector3} from 'three'
import {collectEquipmentGroups} from './equipmentGroups'
import {equipmentGroupBadgePosition,highlightDevice,equipmentSelectionTarget} from './deviceSelection'
const mesh=()=>new Mesh(new BoxGeometry(),new MeshStandardMaterial())
it('combines one recorded axis while preserving distinct identical-name axes and sensors',()=>{
 const root=new Group()
 for(const [key,name] of [['axis:a','Servo axis'],['axis:a','Servo axis'],['axis:b','Servo axis'],['sensor:a','Limit sensor']]){
  const part=new Group();part.userData={equipmentUnit:true,equipmentGroup:key,deviceDisplayName:name};part.add(mesh());root.add(part)
 }
 const groups=collectEquipmentGroups(root,'CELL')
 expect(groups).toHaveLength(3)
 expect(groups.map(g=>g.objects.length)).toEqual([2,1,1])
})
it('does not merge matching axis IDs from separate machine instances',()=>{
 const root=new Group()
 for(let i=0;i<2;i++){const scope=new Group();scope.userData.equipmentScope=true;const part=new Group();part.userData={equipmentUnit:true,equipmentGroup:'axis:a',deviceDisplayName:'Axis A'};part.add(mesh());scope.add(part);root.add(scope)}
 expect(collectEquipmentGroups(root,'CELL')).toHaveLength(2)
})
it('selects an assembly for its motor pieces and an independently marked nested sensor',()=>{
 const root=new Group(),axis=new Group(),motor=new Group(),sensor=new Group(),housing=mesh(),lens=mesh()
 axis.userData={equipmentUnit:true,deviceDisplayName:'Axis A'};motor.userData.deviceDisplayName='Drive motor';sensor.userData={equipmentUnit:true,deviceDisplayName:'Limit sensor'}
 root.add(axis);axis.add(motor,sensor);motor.add(housing);sensor.add(lens)
 expect(equipmentSelectionTarget(housing,root)).toBe(axis)
 expect(equipmentSelectionTarget(lens,root)).toBe(sensor)
 const original=lens.material,housingOriginal=housing.material;const restore=highlightDevice(axis);expect(lens.material).toBe(original);expect(housing.material).not.toBe(housingOriginal);restore()
})

it('places the badge at the extent of the complete equipment rather than its first component',()=>{
 const a=mesh(),b=mesh();b.position.x=4
 expect(equipmentGroupBadgePosition([a,b],new Vector3()).x).toBe(2)
 b.position.x=8
 expect(equipmentGroupBadgePosition([a,b],new Vector3()).x).toBe(4)
})

it('keeps an explicitly recorded mount detector selectable despite its structural-sounding name',()=>{
 const root=new Group(),sensor=new Group(),body=mesh();sensor.userData={equipmentUnit:true,deviceDisplayName:'Jig mount detector'}
 sensor.name='dependency-pose-Jig mount detector';body.name='dependency-part-Jig mount detector';sensor.add(body);root.add(sensor)
 expect(equipmentSelectionTarget(body,root)).toBe(sensor)
 const original=body.material,restore=highlightDevice(sensor);expect(body.material).not.toBe(original);restore()
})
