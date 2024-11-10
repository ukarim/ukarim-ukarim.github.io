# Hiragana/katakana quiz

_Nov 10, 2024_

Learn hiragana/katakana by repetition with this endless quiz.

<div id="quiz">
  <noscript>Sorry, this page requires Javascript to be enabled</noscript>
</div>

<script src="assets/maquette400.min.js"></script>
<script>
(function() {
  const hiragana = [
    ["あ", "a"], ["い", "i"], ["う", "u"], ["え", "e"], ["お", "o"],
    ["か", "ka"], ["き", "ki"], ["く", "ku"], ["け", "ke"], ["こ", "ko"],
    ["さ", "sa"], ["し", "shi"], ["す", "su"], ["せ", "se"], ["そ", "so"],
    ["た", "ta"], ["ち", "chi"], ["つ", "tsu"], ["て", "te"], ["と", "to"],
    ["な", "na"], ["に", "ni"], ["ぬ", "nu"], ["ね", "ne"], ["の", "no"],
    ["は", "ha"], ["ひ", "hi"], ["ふ", "fu"], ["へ", "he"], ["ほ", "ho"],
    ["ま", "ma"], ["み", "mi"], ["む", "mu"], ["め", "me"], ["も", "mo"],
    ["や", "ya"], ["ゆ", "yu"], ["よ", "yo"],
    ["ら", "ra"], ["り", "ri"], ["る", "ru"], ["れ", "re"], ["ろ", "ro"],
    ["わ", "wa"], ["ゐ", "wi"], ["ゑ", "we"], ["を", "wo"],
    ["ん", "n"],
    // diacritics
    ["が", "ga"], ["ぎ", "gi"], ["ぐ", "gu"], ["げ", "ge"], ["ご", "go"],
    ["ざ", "za"], ["じ", "ji"], ["ず", "zu"], ["ぜ", "ze"], ["ぞ", "zo"],
    ["だ", "da"], ["ぢ", "ji"], ["づ", "zu"], ["で", "de"], ["ど", "do"],
    ["ば", "ba"], ["び", "bi"], ["ぶ", "bu"], ["べ", "be"], ["ぼ", "bo"],
    ["ぱ", "pa"], ["ぴ", "pi"], ["ぷ", "pu"], ["ぺ", "pe"], ["ぽ", "po"],
    // digraphs
    ["きゃ", "kya"], ["きゅ", "kyu"], ["きょ", "kyo"],
    ["しゃ", "sha"], ["しゅ", "shu"], ["しょ", "sho"],
    ["ちゃ", "cha"], ["ちゅ", "chu"], ["ちょ", "cho"],
    ["にゃ", "nya"], ["にゅ", "nyu"], ["にょ", "nyo"],
    ["ひゃ", "hya"],["ひゅ", "hyu"],["ひょ", "hyo"],
    ["みゃ", "mya"],["みゅ", "myu"],["みょ", "myo"],
    ["りゃ", "rya"],["りゅ", "ryu"],["りょ", "ryo"],
    // digraphs with diacritics
    ["ぎゃ", "gya"],["ぎゅ", "gyu"],["ぎょ", "gyo"],
    ["じゃ", "ja"],["じゅ", "ju"],["じょ", "jo"],
    ["ぢゃ", "ja"],["ぢゅ", "ju"],["ぢょ", "jo"],
    ["びゃ", "bya"],["びゅ", "byu"],["びょ", "byo"],
    ["ぴゃ", "pya"],["ぴゅ", "pyu"],["ぴょ", "pyo"]
  ];

  const katakana = [
    ['ア', 'a'], ['イ', 'i'], ['ウ', 'u'], ['エ', 'e'], ['オ', 'o'],
    ['カ', 'ka'], ['キ', 'ki'], ['ク', 'ku'], ['ケ', 'ke'], ['コ', 'ko'],
    ['サ', 'sa'], ['シ', 'shi'], ['ス', 'su'], ['セ', 'se'], ['ソ', 'so'],
    ['タ', 'ta'], ['チ', 'chi'], ['ツ', 'tsu'], ['テ', 'te'], ['ト', 'to'],
    ['ナ', 'na'], ['ニ', 'ni'], ['ヌ', 'nu'], ['ネ', 'ne'], ['ノ', 'no'],
    ['ハ', 'ha'], ['ヒ', 'hi'], ['フ', 'fu'], ['ヘ', 'he'], ['ホ', 'ho'],
    ['マ', 'ma'], ['ミ', 'mi'], ['ム', 'mu'], ['メ', 'me'], ['モ', 'mo'],
    ['ヤ', 'ya'], ['ユ', 'yu'], ['ヨ', 'yo'],
    ['ラ', 'ra'], ['リ', 'ri'], ['ル', 'ru'], ['レ', 're'], ['ロ', 'ro'],
    ['ワ', 'wa'], ['ヰ', 'wi'], ['ヱ', 'we'], ['ヲ', 'wo'],
    ['ン', 'n'],
    // diacritics
    ['ガ', 'ga'], ['ギ', 'gi'], ['グ', 'gu'], ['ゲ', 'ge'], ['ゴ', 'go'],
    ['ザ', 'za'], ['ジ', 'ji'], ['ズ', 'zu'], ['ゼ', 'ze'], ['ゾ', 'zo'],
    ['ダ', 'da'], ['ヂ', 'ji'], ['ヅ', 'zu'], ['デ', 'de'], ['ド', 'do'],
    ['バ', 'ba'], ['ビ', 'bi'], ['ブ', 'bu'], ['ベ', 'be'], ['ボ', 'bo'],
    ['パ', 'pa'], ['ピ', 'pi'], ['プ', 'pu'], ['ペ', 'pe'], ['ポ', 'po'],
    // digraphs
    ["キャ", "kya"],["キュ", "kyu"],["キョ", "kyo"],
    ["シャ", "sha"],["シュ", "shu"],["ショ", "sho"],
    ["チャ", "cha"],["チュ", "chu"],["チョ", "cho"],
    ["ニャ", "nya"],["ニュ", "nyu"],["ニョ", "nyo"],
    ["ヒャ", "hya"],["ヒュ", "hyu"],["ヒョ", "hyo"],
    ["ミャ", "mya"], ["ミュ", "myu"], ["ミョ", "myo"],
    ["リャ", "rya"], ["リュ", "ryu"], ["リョ", "ryo"],
    // digraphs with diacritics
    ["ギャ", "gya"], ["ギュ", "gyu"], ["ギョ", "gyo"],
    ["ジャ", "ja"], ["ジュ", "ju"], ["ジョ", "jo"],
    ["ヂャ", "ja"], ["ヂュ", "ju"], ["ヂョ", "jo"],
    ["ビャ", "bya"], ["ビュ", "byu"], ["ビョ", "byo"],
    ["ピャ", "pya"], ["ピュ", "pyu"], ["ピョ", "pyo"]
  ];

  // --------------------------------------------------------------------

  const state = {
    symbols: [],
    remains: [],
    katakana: 0,            // hiragana or katakana
    romaji: 0,              // guessed by kana or romaji
    options: [],
    guess: [],
    correct: 0,
    step: 0,
    slip: false
  };

  function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
    return array;
  }

  function next(kanaChanged) {
    if (state.remains.length < 1 || kanaChanged) {
      let s = state.katakana ? katakana.slice() : hiragana.slice();
      state.symbols = shuffle(s);
      state.remains = state.symbols.slice();
    }
    let selected = state.remains.pop();
    let options = [[selected, false]];
    let acc = [ selected[0] ];
    let len = state.symbols.length;
    for (let i = 0; i < 3; i++) {
      let pair;
      do {
        let r = Math.floor(Math.random() * len);
        pair = state.symbols[r];
      } while(acc.includes(pair[0]));
      options.push([pair, false]);
      acc.push(pair[0]);
    }
    state.options = shuffle(options);
    state.guess = selected;
    state.slip = false;

    if (!kanaChanged) {
      state.step += 1;
    }
  }

  function checkAnsw(e) {
    let answ = e.target.innerText;
    let correct = state.guess[Math.abs(state.romaji - 1)] === answ;
    if (correct) {
      if (!state.slip) {
        state.correct += 1;
      }
      next();
    } else {
      for (let i = 0; i < state.options.length; i++) {
        let option = state.options[i];
        if (option[0][Math.abs(state.romaji - 1)] === answ) {
          option[1] = true;
        }
      }
      state.slip = true;
    }
  }

  function toggleKana() {
    state.katakana = Math.abs(state.katakana - 1);
    next(true);
  }

  function toggleRomaji() {
    state.romaji = Math.abs(state.romaji - 1);
    next(true);
  }

  // ------------------ UI --------------------

  let h = maquette.h;
  let projector = maquette.createProjector();

  function render() {
    let btns = [];
    let options = state.options;
    let missCount = state.step - state.correct - 1;

    for (let i = 0; i < options.length; i++) {
      let option = options[i];
      let tag = option[1] ? 'button.btn.wrong' : 'button.btn';
      btns.push(h(tag, { onclick: checkAnsw, key: 'btn' + i }, [ option[0][Math.abs(state.romaji - 1)] ]));
    }
    btns.push(h('button.btn.blue', { onclick: (e) => next() }, [ 'next' ]));

    return h('div', [
      h('div', ['№ ' + state.step + ' (' + missCount + ' missed)']),
      h('div.msg', [ state.guess[state.romaji] ]),
      h('div', btns),
      h('hr'),
      h('h3', [ 'settings' ]),
      h('button.btn.small', { onclick: toggleKana }, [ state.katakana ? 'switch to hiragana' : 'switch to katakana' ]),
      h('button.btn.small', { onclick: toggleRomaji }, [ state.romaji ? 'guess kana' : 'guess romaji' ])
    ]);
  }

  document.addEventListener('DOMContentLoaded', function () {
    let styles = document.createElement('style');
    styles.innerText = `
      #quiz {
        text-align: center;
      }
      .btn {
        display: block;
        min-width: 150px;
        max-width: 200px;
        background: #ddd;
        border: solid 2px #ddd;
        margin: 1em auto;
        cursor: pointer;
        border-radius: 0.2em;
        padding: 0.2em;
        user-select: none;
      }
      .msg {
        font-size: 5em;
      }
      .blue {
        background: #0070ff;
        border: solid 1px #0070ff;
        color: #fff;
      }
      .wrong {
        border: solid 2px #ff7000;
      }
      .small {
        font-size: 0.8em;
      }
    `;
    document.head.appendChild(styles);
    next();
    projector.append(document.getElementById('quiz'), render);
  });

})();
</script>


