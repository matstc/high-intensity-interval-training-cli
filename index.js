import sampleSize from './node_modules/lodash-es/sampleSize.js'

const WORK = 35
const REST = 10
const SAMPLE_SIZE = 10

let startTime = null
let index = 0
let said = []
let utterances = []
utterances[WORK + 3] = say.bind(null, "Beep")
utterances[WORK + 2] = say.bind(null, "Beep")
utterances[WORK + 1] = say.bind(null, "Beep")
utterances[WORK] = function(activities, index){goFor(activities[index])}
utterances[Math.ceil(WORK / 2 + 1)] = say.bind(null, "Half-way there")
utterances[3] = say.bind(null, "Beep")
utterances[2] = say.bind(null, "Beep")
utterances[1] = say.bind(null, "Beep")
utterances[0] = say.bind(null, "Done")

function reset(){
	index++
	startTime = null
	said = []
}

function prepareFor(activity){
	let shorthand = activity.replace(/\(.*/g,'')
	let readable = "Prepare for " + shorthand.toUpperCase()
	document.querySelector('#PA').textContent = readable
	speechSynthesis.speak(new SpeechSynthesisUtterance(readable))
}

function goFor(activity){
	speechSynthesis.speak(new SpeechSynthesisUtterance("Go!"))
	let shorthand = activity.replace(/\(.*/g,'')
	document.querySelector('#PA').textContent = `Go for ${shorthand.toUpperCase()}`
}

function end(){
	document.querySelector('#PA').textContent = `DONE!`
	speechSynthesis.speak(new SpeechSynthesisUtterance("You're done. Congratulations!"))
	document.querySelector('#stopwatch').innerHTML = "Congratulations"
}

function say(message){
  speechSynthesis.speak(new SpeechSynthesisUtterance(message))
}

function perform(activities){
	if (index === activities.length){ return end() }

  const	firstRun = startTime === null && index === 0

	if (startTime === null) {
		startTime = new Date()
		prepareFor(activities[index])
	}

	let secondsSinceStart = Math.floor((new Date() - startTime) / 1000)
	let secondsRemaining = (WORK + REST) - secondsSinceStart

	document.querySelector('#stopwatch').textContent = secondsRemaining

	if (utterances[secondsRemaining] && said[secondsRemaining] === undefined) {
		utterances[secondsRemaining](activities, index, secondsRemaining)
		said[secondsRemaining] = true
	}

	if (secondsRemaining < 1){ reset() }

	requestAnimationFrame(perform.bind(null, activities))
}

export default function main(){
	document.addEventListener('DOMContentLoaded', function(){
		fetch('/workout.txt').then(response => response.text()).then(function(data){
			let all = data.split('\n').filter(s => s.trim() !== '')
			let activities = sampleSize(all.filter(s => s[0] !== '#'), SAMPLE_SIZE)

			document.querySelector('#setlist').innerHTML = '<ol>' + activities.map(a => `<li>${a}</li>`).join('') + '</ol>'

		  perform(activities)
		})
	})
}
