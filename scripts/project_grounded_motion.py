"""Recorded-axis mechanisms using the existing viewer's industrial assembly idiom.

Visual support/drive details only; no new actuator, sensor, product or judge rule.
Dimensions are schematic except the explicitly recorded coordinate transforms.
"""
from math import sin,cos,radians
NAMES={6:['upper opening','lower opening','empty transfer'],7:['cross travel','approach height'],8:['datum magazine height','empty approach'],9:['guide position','left clamp','right clamp','internal tool'],10:['L-shaped path','dual-sided head angle'],11:['index','first tool','second tool'],12:['first extension','second extension','height'],13:['height','requested tilt','cross approach'],15:['first-direction datum','second-direction datum','approach tool'],16:['alignment table','empty carriage'],17:['feeder','head rotation','cross travel','lift'],18:['home travel','internal tool','search height'],19:['travel','guide']}
from dependencies.spatial.mechanisms import bodies

ALLOY='#a3afb9';STEEL='#7f8f9c';DARK='#35434e';BLUE='#50768e';AMBER='#d7a33f';TEAL='#238d88'
class Assembly:
 def __init__(self):self.parts=[];self.poses={}
 def part(self,name,pos,size,color=ALLOY,node=None,shape='box',style=None,axis='y'):
  p=dict(name=name,pos=pos,size=size,color=color,shape=shape,axis=axis)
  if node:p['node']=node
  if style:p['style']=style
  self.parts.append(p)
 def pose(self,name,pos,angle=0,axis='y'):
  q=[0,0,0,cos(radians(angle)/2)];q['xyz'.index(axis)]=sin(radians(angle)/2)
  self.poses[name]=dict(pos=pos,quaternion=q,scale=[1,1,1])
 def rod(self,name,start,end,r=.008,color=STEEL,node=None):
  lengths=[abs(b-a) for a,b in zip(start,end)];a=lengths.index(max(lengths));size=[2*r]*3;size[a]=max(lengths[a],.001)
  self.part(name,[(a+b)/2 for a,b in zip(start,end)],size,color,node,shape='cylinder',axis='xyz'[a])
 def slide(self,name,pos,length=.7,axis='x',node=None):
  # Two supported guideways, central drive and end-mounted motor. Moving saddles are separate.
  i='xyz'.index(axis);cross=2 if axis=='x' else 0
  def offset(d,side=0):
   p=list(pos);p[i]+=d;p[cross]+=side;return p
  size=[.085,.025,.085];size[i]=length+.12
  self.part(name+'-bed',offset(length/2),size,DARK,node,style='plate')
  for side in [-.034,.034]:
   sz=[.012,.012,.012];sz[i]=length
   self.part(name+f'-rail-{side}',offset(length/2,side),sz,STEEL,node,style='rail')
  self.rod(name+'-screw',offset(0),offset(length),.007,STEEL,node)
  for d in [0,length]:
   sz=[.095,.045,.095];sz[i]=.025
   self.part(name+'-end-'+str(d),offset(d),sz,ALLOY,node,style='plate')
  sz=[.07,.07,.07];sz[i]=.10
  self.part(name+'-motor',offset(-.075),sz,BLUE,node,style='motor',axis=axis)
 def actuator(self,name,anchor,tip,axis='y',node=None):
  i='xyz'.index(axis);direction=1 if tip[i]>=anchor[i] else -1
  body=list(anchor);body[i]-=direction*.075;size=[.065]*3;size[i]=.15
  self.part(name+'-body',body,size,ALLOY,node,style='actuator',axis=axis)
  self.rod(name+'-rod',anchor,tip,.008,STEEL,node)
 def pedestal(self,name,x,y,z=0):
  self.part(name+'-foot',[x,.085,z],[.16,.035,.14],DARK,style='plate')
  self.part(name+'-column',[x,(.1+y)/2,z],[.055,y-.1,.06],BLUE,style='rail')

def geometry(n,state,request=None):
 request=state["setup"]["request"];a=Assembly();p=a.part;x=lambda k:state['axes'][k]['position']/1000;deg=lambda k:state['axes'][k]['position']
 # Slotted mounting deck and visible feet follow the existing Material/Motion assemblies.
 p('base',[.135 if n==6 else .1 if n==13 else .30,.04,-.10 if n==13 else .20 if n==10 else .08],[1.45 if n==6 else .9 if n==13 else 1.12,.06,1.2 if n==13 else 1.10 if n==10 else .82],DARK,style='base')
 for xx in ([-.50,.75] if n==6 else [-.27,.47] if n==13 else [-.19,.79]):
  for zz in ([-.62,.42] if n==13 else [-.26,.42]):p(f'foot-{xx}-{zz}',[xx,.008,zz],[.10,.016,.08],STEEL,style='plate')
 def saddle(node,pos,size=(.10,.045,.13),color=AMBER):
  a.pose(node,list(pos));p(node+'-saddle',[0,0,0],list(size),color,node,style='carriage')
 def horizontal(k,y=.25,z=0,length=.65,supported=True):
  a.slide(k,[0,y,z],length);saddle(k,[x(k),y+.035,z])
  if supported:
   for xx in [.045,length-.045]:p(k+'-bed-support'+str(xx),[xx,(.07+y-.013)/2,z],[.035,y-.083,.075],BLUE,style='rail')
 def gantry(k,y=.58,z=0,length=.65):
  for xx in [-.10,length+.08]:a.pedestal(k+str(xx),xx,y,z+.075)
  horizontal(k,y,z,length,supported=False)
  for xx in [-.075,length+.045]:p(k+'-gantry-cap'+str(xx),[xx,y-.023,z+.04],[.12,.035,.15],ALLOY,style='plate')
 def vertical(k,xx,z=0,base=.18,top=.60,parent=None):
  a.slide(k,[xx,base,z+.06],top-base,'y',parent)
  saddle(k,[xx,base+x(k),z])
 if n==6:
  a.slide('c',[-.45,.42,0],.40);saddle('c',[x('c')-.45,.455,0])
  
  for z in [-.027,.027]:a.rod('transfer-ram'+str(z),[x('c')-.45,.455,z],[x('c')+.025,.455,z],.006)
  for xx in [-.42,-.10]:
   a.pedestal('transfer'+str(xx),xx,.42,.10)
   p('transfer-bed-cap'+str(xx),[xx,.395,.05],[.10,.035,.18],STEEL,style='plate')
  for xx in [.17,.42]:a.pedestal('press'+str(xx),xx,.74,.16)
  
  for z in [-.16,.16]:p('press-crown'+str(z),[.295,.75,z],[.40,.05,.04],ALLOY,style='plate')
  p('lower-actuator-foot',[.295,.075,0],[.085,.01,.085],ALLOY,style='plate')
  for k,yy,anchor in [('a',.4775+x('a'),.70),('b',.4325-x('b'),.23)]:
   saddle(k,[.295,yy,0],[.31,.045,.26],ALLOY)
   a.actuator(k+'-opening',[.40,anchor,0],[.40,yy,0])
   for xx in [.19,.40]:a.rod(k+str(xx),[xx,.24,.14],[xx,.72,.14],.008)
  xx=request['target']/1000+.025
  for z in [-.10,.10]:
   a.pedestal('cap-guide'+str(z),xx,.24,z)
   a.slide('cap-lift'+str(z),[xx,.24,z],.14,'y')
   p('cap-cross-arm'+str(z),[xx,.325+x('d'),z/2],[.045,.025,.10],STEEL)
  a.actuator('d-cap',[xx,.20,0],[xx,.3375+x('d'),0])
  for z in [-.16,.16]:a.pedestal('tool-frame'+str(z),xx,.96,z)
  p('tool-crosshead',[xx,.94,0],[.11,.04,.36],ALLOY,style='plate')
  a.actuator('e-tool',[xx,.85,0],[xx,.77-x('e'),0])
 elif n==7:
  gantry('a',.57,length=.68);vertical('b',x('a'),base=.34,top=.57)
  a.slide('c-cross',[x('a'),.34+x('b'),0],.12,'z')
  saddle('c',[x('a'),.34+x('b'),x('c')],[.07,.035,.045])
  p('probe-stem',[0,-.08,0],[.014,.16,.014],STEEL,'c',shape='cylinder')
  p('probe-link',[x('a'),.33+x('b'),x('c')],[.026,.02,.024],STEEL)

  p('tool-tip',[0,-.055,0],[.022,.07,.025],STEEL,'b',shape='cylinder')
  for key in ['first','second']:
   xx=request[key]/1000;p(key+'-port-foot',[xx,.085,0 if key=='first' else request['reach']/1000],[.065,.03,.08],BLUE,style='plate')
 elif n==8:
  a.pedestal('rack',.20,.95,.12);vertical('a',.20,base=.17,top=.92)
  p('magazine-spine',[-.055,.22,0],[.02,.62,.16],ALLOY,'a',style='plate')
  a.slide('b',[.40,.51,.05],.15,'z');saddle('b',[.40,.55,.20-x('b')])
  for z in [.06,.19]:p('access-bed-support'+str(z),[.40,.28,z],[.055,.42,.03],BLUE,style='rail')
  p('datum-sensor',[.13,.70,.12],[.025,.025,.025],TEAL)
  p('datum-cam',[.145,.50+x('a')-state['setup']['mark']/1000,.10],[.012,.40,.02],STEEL)
 elif n==9:
  horizontal('a',.26,length=.25);p('guide-deck',[0,.06,0],[.20,.025,.27],ALLOY,'a',style='plate')
  p('clamp-mount-span',[0,.05,0],[.10,.035,.66],STEEL,'a',style='plate')
  for k,side in [('b',-1),('c',1)]:
   a.pose(k,[x('a'),.39,side*(.20-x(k))]);p(k+'-jaw',[0,0,0],[.09,.06,.035],AMBER,k,style='carriage')
   a.actuator(k,[x('a'),.39,side*.30],[x('a'),.39,side*(.20-x(k))],'z')
  a.pedestal('tool',.30,.74,-.21);p('tool-crown',[.20,.74,-.10],[.32,.045,.30],ALLOY,style='plate')
  saddle('d',[.10,.62-x('d'),0],[.06,.10,.06]);a.actuator('d',[.10,.68,0],[.10,.67-x('d'),0])
  p('internal-probe',[.10,.505-x('d'),0],[.016,.14,.016],STEEL)
  for side in [-1,1]:
   if side==1:a.pedestal('receiver-support',.30,.44,.25)
   p('receiver-backbeam'+str(side),[.20,.44,side*.25],[.20,.025,.04],STEEL,style='plate')
   p('receiver-crossbeam'+str(side),[.10,.44,side*.145],[.06,.025,.21],STEEL,style='plate')
   for xx in [.0815,.1185]:p('receiver-hanger'+str(side)+str(xx),[xx,.42125,side*.04],[.012,.0375,.012],STEEL)
 elif n==10:
  s=x('a');xx,zz=(s,0) if s<=.5 else (.5,s-.5)
  a.slide('path-x',[0,.56,0],.5)
  a.pose('path-cross',[min(s,.5),.60,0]);p('cross-saddle',[0,0,0],[.12,.04,.14],STEEL,'path-cross',style='carriage')
  a.slide('path-z',[0,.045,0],.5,'z','path-cross')
  for xxp,zzp in [(-.1,.1),(.6,.6)]:a.pedestal('path'+str(xxp),xxp,.56,zzp)
  p('path-start-cap',[-.05,.54,.05],[.16,.04,.18],ALLOY,style='plate')
  p('path-end-cap',[.55,.54,.55],[.18,.04,.18],ALLOY,style='plate')
  saddle('a',[xx,.68,zz]);a.rod('wrist',[xx,.68,zz],[xx,.24,zz],.017)
  a.pose('b',[xx,.24,zz],-deg('b'));p('two-sided-head',[0,0,0],[.20,.035,.04],AMBER,'b',style='plate')
  # Schematic rails outline the public corridor union and turning bay; they are not collision meshes.
  segments=[('h1',[-.2,.24,-.055],[.35,.24,-.055]),('h2',[-.2,.24,.055],[.35,.24,.055]),('bay-left',[.34,.24,.055],[.34,.24,.15]),('bay-bottom',[.35,.24,-.16],[.65,.24,-.16]),('bay-right',[.66,.24,-.15],[.66,.24,.15]),('v1',[.445,.24,.15],[.445,.24,.65]),('v2',[.555,.24,.15],[.555,.24,.65])]
  for name,u,v in segments:
   size=[max(abs(v[i]-u[i]),.02) for i in range(3)];size[1]=.09
   p(name,[(u[i]+v[i])/2 for i in range(3)],size,STEEL,style='rail')
   for j,end in enumerate([u,v]):p(name+'-standoff'+str(j),[end[0],.1325,end[2]],[.02,.125,.02],BLUE)
 elif n==11:
  p('index-pedestal',[.33,.18,0],[.27,.21,.27],BLUE,style='motor')
  p('index-bearing',[.33,.295,0],[.24,.035,.24],STEEL,shape='cylinder')
  a.pose('a',[.33,.33,0],deg('a'));p('index-disc',[0,0,0],[.35,.035,.35],ALLOY,'a',shape='bored_disc',style='rotor')
  disc=a.parts[-1];disc['holes']=[]
  for k,side,key in [('b',1,'first'),('c',-1,'second')]:
   angle=radians(request.get(key,90 if k=='b' else 180));xx=.33+side*.11
   disc['holes'].append(dict(x=side*.11*cos(angle)/.35,z=side*.11*sin(angle)/.35,radius=.012/.35))
   p(k+'-port',[side*.11*cos(angle),.021,side*.11*sin(angle)],[.040,.006,.040],TEAL,'a',shape='ring')
   a.pedestal(k,xx,.64,-.16);p(k+'-arm',[xx,.64,-.06],[.055,.04,.25],ALLOY,style='plate')
   saddle(k,[xx,.50-x(k),0],[.045,.07,.045]);a.actuator(k,[xx,.60,0],[xx,.535-x(k),0])
   p(k+'-tip',[0,-.055,0],[.015,.04,.015],STEEL,k,shape='cylinder')
 elif n==12:
  a.pedestal('lift',.08,.53,.12);vertical('c',.08,base=.18,top=.50)
  yy=.22+x('c');a.slide('a',[.08,yy,0],.10);saddle('a',[.08+x('a'),yy+.035,0])
  p('second-stage-outer',[.105+x('a'),yy+.105,0],[.13,.065,.08],STEEL,style='actuator',axis='x')
  p('second-stage-middle',[.105+x('a')+x('b')/2,yy+.105,0],[.13,.045,.06],ALLOY)
  p('second-stage-inner',[.105+x('a')+x('b'),yy+.105,0],[.13,.025,.04],STEEL)
  p('second-stage-mount',[.105+x('a'),yy+.065,0],[.09,.03,.075],ALLOY)
  p('second-stage-motor',[.03+x('a'),yy+.08,0],[.04,.05,.055],BLUE,style='motor',axis='x')
  saddle('b',[.08+x('a')+x('b'),yy+.105,0],[.08,.035,.09])
  p('telescopic-tool',[.05,0,0],[.10,.025,.05],AMBER,'b')
  p('docking-key-bracket',[0,-.025,-.06],[.025,.025,.13],STEEL,'a')
  p('docking-key-neck',[0,-.05,-.12],[.008,.04,.012],STEEL,'a')
  p('lift-deck',[.02,.012,0],[.18,.026,.17],ALLOY,'c',style='plate')
 elif n==13:
  vertical('a',0,z=-.28,base=.23,top=.65)
  a.pose('b',[0,.28+x('a'),-.50],deg('b'),'z')
  p('tilt-housing',[0,.28+x('a'),-.56],[.10,.10,.07],BLUE,style='motor',axis='z')
  p('tilt-flange',[0,0,0],[.10,.10,.025],STEEL,'b',shape='cylinder',axis='z')
  a.slide('c',[0,.04,0],.45,'z','b')
  t=radians(deg('b'));cx=-.08*sin(t);cy=.28+x('a')+.08*cos(t)
  saddle('c',[cx,cy,x('c')-.50],[.05,.045,.065])
  a.rod('access-ram',[cx,cy,x('c')-.50],[cx,cy,x('c')-.025],.008)
  p('lift-tilt-mount',[0,.25+x('a'),-.39],[.08,.045,.24],STEEL)
  t=radians(request['angle']);cx=-.08*sin(t);cy=.40+.08*cos(t)
  for side in [-1,1]:
   xx=cx+side*.025*cos(t)+.118*sin(t);yy=cy+side*.025*sin(t)-.118*cos(t)
   a.pedestal('aperture'+str(side),xx,yy+.005,.15)
  zz=request['target']/1000-.025
  for xx in [-.09,.07]:
   a.pedestal('receiver-base'+str(xx),xx,.19,zz)
   a.slide('d-lift'+str(xx),[xx,.19,zz],.18,'y')
  a.actuator('receiver',[0,.17,zz],[0,.28+x('d'),zz])
  p('receiver-table',[0,.28+x('d'),zz],[.18,.025,.15],ALLOY,style='plate')
  cy=.38+.08*cos(t)+(x('d')-request['receive']/1000)
  yy=cy-.095*cos(t)-.022
  p('receiver-cradle-neck',[cx+.095*sin(t),(.2925+x('d')+yy)/2,zz],[.04,max(.005,yy-.2925-x('d')),.065],STEEL)
 elif n==15:
  horizontal('c',.26,length=.35)
  p('orientation-fixture',[.12+request['target']/1000,.20,0],[.16,.028,.16],ALLOY,style='plate')
  p('datum-mount-span',[.12+request['target']/1000,.325,0],[.10,.025,.66],STEEL,style='plate')
  for side in [-1,1]:p('datum-mount-leg'+str(side),[.12+request['target']/1000,.20,side*.27],[.075,.25,.065],BLUE,style='rail')
  for k,side in [('a',-1),('b',1)]:
   a.pose(k,[.12+request['target']/1000,.37,side*(.13-x(k))]);p(k+'-datum',[0,0,0],[.055,.055,.025],AMBER,k,style='carriage')
   a.actuator(k,[.12+request['target']/1000,.37,side*.20],[.12+request['target']/1000,.37,side*(.13-x(k))],'z')
  p('direction-indicator',[.38,.35,.13],[.026,.018,.045],TEAL)
  xx=request['target']/1000+.12
  for dx in [-.045,.045]:p('shuttle-support'+str(dx),[x('c')+.12+dx,.3275,0],[.02,.035,.065],STEEL)
  for z in [-.0525,.0525]:p('datum-contact-land'+str(z),[x('c')+.12,.37,z],[.10,.03,.010],ALLOY)
  p('shuttle-neck',[x('c')+.06,.3075,0],[.16,.02,.065],STEEL)
  for z in [-.17,.17]:a.pedestal('tool-column'+str(z),xx,.71,z)
  p('tool-crown',[xx,.70,0],[.095,.035,.39],ALLOY,style='plate')
  a.actuator('d-work',[xx,.59,0],[xx,.53-x('d'),0])
 elif n==16:
  xx=request['target']/1000;zz=.18-request['depth']/1000
  horizontal('a',.25,length=.38)
  p('table-bore-bridge',[x('a'),.313,.05],[.12,.012,.19],ALLOY,style='plate')
  for side in [-1,1]:
   p('table-bore-support'+str(side),[x('a')+side*.032,.3575,zz],[.018,.10,.07],BLUE)
   p('carrier-bore-support'+str(side),[xx+side*.03,.4175,.18-x('b')],[.016,.055,.06],STEEL)
  a.slide('b',[xx,.33,.02],.16,'z');saddle('b',[xx,.365,.18-x('b')],[.065,.05,.10])
  p('carriage-bed-support',[xx,.195,.18],[.06,.25,.05],BLUE,style='rail')
  a.pedestal('module',xx,.71,-.19);p('module-arm',[xx,.70,-.045],[.09,.04,.36],ALLOY,style='plate')
  yy=.53-state.get('module_position',0)/1000;a.pose('module',[xx,yy,zz])
  a.actuator('module',[xx,.65,zz],[xx,yy+.05,zz])
 elif n==17:
  for xx in [-.25,-.02]:p('feeder-bed-foot'+str(xx),[xx,.14375,0],[.06,.1475,.085],BLUE,style='rail')
  a.slide('a',[-.28,.23,0],.30);saddle('a',[x('a')-.28,.265,0])
  p('feeder-upright',[0,.11,-.12],[.09,.22,.04],BLUE,'a',style='plate')
  p('feeder-fork-back',[0,.15,-.09],[.24,.05,.07],ALLOY,'a',style='plate')
  gantry('c',.81,.10,length=.44);vertical('d',x('c'),z=.1,base=.56,top=.80)
  a.pose('b',[x('c'),.415+x('d'),0],deg('b'))
  p('head-flange',[0,.035,0],[.07,.025,.07],STEEL,'b',shape='cylinder')
  p('head-mount',[x('c'),.58+x('d'),.065],[.045,.035,.13],ALLOY)
  a.rod('head-spindle',[x('c'),.45+x('d'),0],[x('c'),.58+x('d'),0],.012)
  for side in [-1,1]:a.pedestal('destination'+str(side),request['target']/1000+side*.08,.37,.08)
 elif n==18:
  gantry('a',.61,length=.38);vertical('c',x('a'),z=-.18,base=.30,top=.60)
  p('recovery-stage-mount',[x('a'),.59,-.07],[.08,.035,.24],STEEL)
  p('internal-tool-mount',[x('a'),.30+x('c'),-.105],[.045,.035,.18],ALLOY)
  p('recovery-key-neck',[x('a'),.2875+x('c'),0],[.012,.035,.015],STEEL)
  yy=.30+x('c');a.pose('b',[x('a'),yy,.02+x('b')])
  a.actuator('inner',[x('a'),yy,-.04],[x('a'),yy,.02+x('b')],'z')
  p('reference-sensor',[.35,.62,.16],[.018,.025,.02],TEAL)
  p('reference-cam',[.15+x('a')-state['setup']['mark']/1000,.62,.14],[.40,.012,.015],STEEL)
  for xx in [-.035,.43]:a.pedestal('guard'+str(xx),xx,.33,.095)
 elif n==19:
  gantry('a',.57,z=-.12,length=.66)
  a.slide('d-cross',[x('a'),.64,-.12],.28,'z')
  p('cross-mount',[x('a'),.6225,-.12],[.10,.035,.10],STEEL)
  saddle('d',[x('a'),.675,x('d')],[.08,.035,.08])
  a.actuator('b-guide',[x('a'),.54,x('d')],[x('a'),.42-x('b'),x('d')])
  for xx in [.20,.40]:
   a.slide('c-base'+str(xx),[xx,.20,0],.22,'z')
   for zz in [0,.22]:a.pedestal('base-foot'+str(xx)+str(zz),xx,.19,zz)
  p('c-platform',[.30,.2425,.07+x('c')],[.33,.025,.16],ALLOY,style='plate')
  for lane in [.04,.10]:
   for xx in [request['first']/1000,request['second']/1000]:p('zone-mark'+str(xx)+str(lane),[xx,.322,lane+x('c')-.025],[.005,.005,.012],TEAL)
 # Passive guideways share a rigid carriage; each added axis has one drive.
 passive=('cap-lift','d-lift')
 a.parts=[part for part in a.parts if not (part['name'].startswith(passive) and part['name'].endswith(('-motor','-screw'))) and part['name'] not in ['c-base0.4-motor','c-base0.4-screw']]
 replacements={6:['transfer-nose','a-saddle','b-saddle'],7:['tool-tip'],8:[],9:[],11:['b-tip','c-tip'],12:['telescopic-tool','b-saddle'],13:[],15:['a-datum','b-datum'],16:[],17:[],18:[],19:['guide-tip','slot-rail-0.055','slot-rail0.055']}
 a.parts=[p for p in a.parts if p['name'] not in replacements.get(n,[])]
 core,pairs=bodies(n,{k:v['position'] for k,v in state['axes'].items()},state['setup'],state.get('module_position',0))
 for solid in core:
  node='protected-'+solid['name'];a.pose(node,solid['pos'],solid['angle'],solid['axis'])
  shape='cylinder' if n==11 else 'box'
  p(solid['name'],[0,0,0],solid['size'],AMBER if solid['moving'] else ALLOY,node,shape=shape)
  a.parts[-1]['protected_body']=True
 # Fixed supports are visible but are not extra PLC mechanisms or scored pairs.
 return dict(version='motion-grounded-geometry/4.1',task_number=n,parts=a.parts,poses=a.poses,
   labels={k:f'{k.upper()} · {s}' for k,s in zip(state['axes'],NAMES[n])},axis_labels={k:f'{k.upper()} · {s}' for k,s in zip(state['axes'],NAMES[n])},local_dwell_required=False,
   protected_pairs=[list(pair) for pair in pairs],interpretation='v6 protected bodies share evaluator transforms; supports and drives are visual details; not whole-machine CAD certification')
