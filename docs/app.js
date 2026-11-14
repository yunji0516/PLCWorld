'use strict';
const tasks = [
  {id:'MOT-E01',suite:'motion',level:'Easy',title:'Single-slide positioning',description:'Move the slide to the requested position, confirm arrival and standstill, and maintain the completed state.'},
  {id:'MAT-E01',suite:'material',level:'Easy',title:'Local workpiece acquisition',description:'Close the gripper on a workpiece at a prepared position and confirm that the workpiece is held.'},
  {id:'MOT-M14',suite:'motion',level:'Medium',title:'Rotary-table and slide coordination',description:'Retract the slide, maintain clearance during table rotation, and approach only after alignment and standstill.'},
  {id:'MAT-M04',suite:'material',level:'Medium',title:'Routing inspected workpieces',description:'Read each arriving workpiece’s inspection class, then coordinate pickup, transfer, and placement at its accept or reject receiver.'},
  {id:'MOT-H15',suite:'motion',level:'Hard',title:'Balance-controlled pocket access',description:'Coordinate independent access requests through a shared transfer mechanism and balance-controlled pockets.'},
  {id:'MAT-H01',suite:'material',level:'Hard',title:'Shared robot and machining cells',description:'Coordinate two machining orders with a shared robot, including loading, processing, inspection, and outfeed.'},
];
const suiteNames={motion:'Motion Control',material:'Material Handling'};
document.getElementById('task-grid').innerHTML=tasks.map(t=>`<article class="task-card" data-suite="${t.suite}"><div class="task-media"><video muted loop playsinline controls preload="none" poster="assets/posters/${t.id}.webp?v=20261114-front" data-src="assets/videos/${t.id}.mp4?v=20261114-front" aria-label="${t.title} reference replay"></video></div><div class="task-copy"><div class="task-meta"><span class="level ${t.level.toLowerCase()}">${t.level}</span><span>${suiteNames[t.suite]}</span><code>${t.id}</code></div><h3>${t.title}</h3><p>${t.description}</p><div class="task-links"><a href="assets/videos/${t.id}.mp4?v=20261114-front" download>Download video ↓</a></div></div></article>`).join('');
const videos=[...document.querySelectorAll('video')];
const reducedMotion=window.matchMedia('(prefers-reduced-motion: reduce)');
let videosPaused=reducedMotion.matches;
const visibleVideos=new Set();
function loadVideo(video){if(!video.getAttribute('src')){video.src=video.dataset.src;video.load();}}
function tryPlay(video){if(!videosPaused&&!document.hidden&&!video.closest('[hidden]')){loadVideo(video);video.play().catch(()=>{});}}
const observer=new IntersectionObserver(entries=>entries.forEach(({target,isIntersecting})=>{if(isIntersecting){visibleVideos.add(target);loadVideo(target);tryPlay(target);}else{visibleVideos.delete(target);target.pause();}}),{threshold:.2});
videos.forEach(v=>{v.muted=true;observer.observe(v);});
const pauseButton=document.getElementById('toggle-videos');
function updatePauseButton(){pauseButton.textContent=videosPaused?'Play videos':'Pause videos';pauseButton.setAttribute('aria-pressed',String(videosPaused));}
updatePauseButton();
pauseButton.addEventListener('click',()=>{videosPaused=!videosPaused;updatePauseButton();videos.forEach(v=>{if(videosPaused)v.pause();else if(visibleVideos.has(v))tryPlay(v);});});
document.addEventListener('visibilitychange',()=>{videos.forEach(v=>{if(document.hidden)v.pause();else if(visibleVideos.has(v))tryPlay(v);});});
reducedMotion.addEventListener('change',e=>{videosPaused=e.matches;updatePauseButton();videos.forEach(v=>{if(videosPaused)v.pause();else if(visibleVideos.has(v))tryPlay(v);});});
document.querySelectorAll('button[data-suite]').forEach(button=>button.addEventListener('click',()=>{
  document.querySelectorAll('button[data-suite]').forEach(b=>{b.classList.toggle('active',b===button);b.setAttribute('aria-pressed',String(b===button));});
  let count=0;
  document.querySelectorAll('.task-card').forEach(card=>{const show=button.dataset.suite==='all'||card.dataset.suite===button.dataset.suite;card.hidden=!show;if(show)count++;else card.querySelector('video').pause();});
  document.getElementById('gallery-status').textContent=`Showing ${count} ${button.dataset.suite==='all'?'':suiteNames[button.dataset.suite]+' '}tasks`;
}));

// Values transcribed from the main results table in the supplied manuscript.
const results={"direct": [["GPT-5.5", [73.33, 1.67, 75.58, 7.05, 15.97, 65.12], [97.83, 0.0, 93.06, 1.77, 27.87, 32.24], 37.33], ["GPT-4o", [7.78, 0.0, 0.0, 21.28, 0.0, 37.5], [10.14, 21.21, 1.04, 0.0, 0.0, 57.14], 87.67], ["Claude Sonnet 5", [77.78, 2.38, 72.28, 24.18, 0.0, 72.5], [85.51, 0.78, 71.18, 1.11, 4.37, 53.1], 49.5], ["Gemini 3.1 Pro", [73.33, 0.0, 63.04, 20.43, 11.81, 62.96], [88.41, 0.0, 74.65, 1.38, 22.13, 54.77], 33.17], ["Gemini 3.8 Flash", [95.56, 0.0, 76.9, 18.02, 4.86, 75.0], [100.0, 0.0, 88.54, 0.0, 17.21, 32.37], 30.68], ["Qwen3.5-Plus", [65.56, 6.41, 55.12, 35.57, 0.0, 50.0], [86.23, 2.17, 46.18, 24.11, 1.64, 61.7], 46.86]], "frameworks": [["Direct (GPT-5.5, matched)", [70.0, 5.0, 75.25, 5.21, 22.92, 73.33], [93.48, 0.0, 85.42, 5.56, 28.69, 34.43], 39.22], ["LLM4PLC", [68.33, 0.0, 77.23, 4.95, 0.0, 43.75], [97.83, 0.0, 84.38, 6.25, 23.77, 48.36], 44.35], ["Agents4PLC", [73.33, 3.33, 77.23, 10.89, 0.0, 79.17], [84.78, 0.0, 71.88, 0.0, 16.39, 27.87], 48.84], ["AutoPLC", [80.0, 0.0, 75.25, 4.95, 12.5, 71.43], [100.0, 0.0, 87.5, 7.29, 31.15, 25.41], 40.69], ["SemaPLC", [78.33, 0.0, 65.35, 0.99, 12.5, 85.42], [86.96, 0.0, 94.79, 0.0, 9.84, 39.34], 45.53]]};
let setting='direct';
function renderResults(){const suite=document.getElementById('result-suite').value;const column=suite==='motion'?1:2;const rows=results[setting];const best=Array.from({length:6},(_,i)=>(i%2?Math.min:Math.max)(...rows.map(r=>r[column][i])));document.getElementById('results-body').innerHTML=rows.map(r=>`<tr><th scope="row">${r[0]}</th>${r[column].map((v,i)=>`<td class="${v===best[i]?'best':''}">${v.toFixed(2)}</td>`).join('')}<td>${r[3].toFixed(2)}</td></tr>`).join('');document.getElementById('results-caption').textContent=`${setting==='direct'?'Direct ST generation':'Adapted workflows · GPT-5.5 backbone'} · ${suiteNames[suite]} · Results (%)`}
document.querySelectorAll('[data-setting]').forEach(button=>button.addEventListener('click',()=>{setting=button.dataset.setting;document.querySelectorAll('[data-setting]').forEach(b=>{b.classList.toggle('active',b===button);b.setAttribute('aria-pressed',String(b===button));});renderResults();}));
document.getElementById('result-suite').addEventListener('change',renderResults);renderResults();

const citationButton = document.getElementById('copy-citation');
citationButton.addEventListener('click', async () => {
  const code = document.getElementById('citation-code');
  const status = document.getElementById('citation-status');
  try {
    await navigator.clipboard.writeText(code.textContent);
    status.textContent = 'BibTeX copied to clipboard.';
  } catch {
    const selection = window.getSelection();
    const range = document.createRange();
    range.selectNodeContents(code);
    selection.removeAllRanges();
    selection.addRange(range);
    status.textContent = 'Select and copy the highlighted BibTeX.';
  }
});
