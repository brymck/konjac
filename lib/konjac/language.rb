module Konjac
  # A class for language lookup
  module Language
    class << self
      # Languages that don't use spaces. Obviously this is an incomplete list.
      LANGUAGES_WITHOUT_SPACES = [:ar, :he, :ja, :zh]

      # A hash list of languages. The keys are the two-letter ISO codes and the
      # values are alternative names, including the three-letter ISO code and
      # the English name
      LIST = {
        :ab => [:abkhazian,           :abk],
        :aa => [:afar,                :aar],
        :af => [:afrikaans,           :afr],
        :ak => [:akan,                :aka],
        :sq => [:albanian,            :alb, :sqi],
        :am => [:amharic,             :amh],
        :ar => [:arabic,              :ara],
        :an => [:aragonese,           :arg],
        :hy => [:armenian,            :arm, :hye],
        :as => [:assamese,            :asm],
        :av => [:avaric,              :ava],
        :ae => [:avestan,             :ave],
        :ay => [:aymara,              :aym],
        :az => [:azerbaijani,         :aze],
        :bm => [:bambara,             :bam],
        :ba => [:bashkir,             :bak],
        :eu => [:basque,              :baq, :eus],
        :be => [:belarusian,          :bel],
        :bn => [:bengali,             :ben],
        :bh => [:bihari,              :bih],
        :bi => [:bislama,             :bis],
        :nb => [:bokmal,              :nob],
        :bs => [:bosnian,             :bos],
        :br => [:breton,              :bre],
        :bg => [:bulgarian,           :bul],
        :my => [:burmese,             :bur, :mya],
        :es => [:castilian,           :spa],
        :ca => [:catalan,             :cat],
        :km => [:central_khmer,       :khm],
        :ch => [:chamorro,            :cha],
        :ce => [:chechen,             :che],
        :ny => [:chewa,               :nya],
        :ny => [:chichewa,            :nya],
        :zh => [:chinese,             :chi, :zho],
        :za => [:chuang,              :zha],
        :cv => [:chuvash,             :chv],
        :kw => [:cornish,             :cor],
        :co => [:corsican,            :cos],
        :cr => [:cree,                :cre],
        :hr => [:croatian,            :hrv],
        :cs => [:czech,               :cze, :ces],
        :da => [:danish,              :dan],
        :dv => [:dhivehi,             :div],
        :dv => [:divehi,              :div],
        :nl => [:dutch,               :dut, :nld],
        :dz => [:dzongkha,            :dzo],
        :en => [:english,             :eng],
        :eo => [:esperanto,           :epo],
        :et => [:estonian,            :est],
        :ee => [:ewe,                 :ewe],
        :fo => [:faroese,             :fao],
        :fj => [:fijian,              :fij],
        :fi => [:finnish,             :fin],
        :nl => [:flemish,             :dut, :nld],
        :fr => [:french,              :fre, :fra],
        :ff => [:fulah,               :ful],
        :gd => [:gaelic,              :gla],
        :gl => [:galician,            :glg],
        :lg => [:ganda,               :lug],
        :ka => [:georgian,            :geo, :kat],
        :de => [:german,              :ger, :deu],
        :ki => [:gikuyu,              :kik],
        :el => [:greek,               :gre, :ell],
        :kl => [:greenlandic,         :kal],
        :gn => [:guarani,             :grn],
        :gu => [:gujarati,            :guj],
        :ht => [:haitian,             :hat],
        :ht => [:haitian_creole,      :hat],
        :ha => [:hausa,               :hau],
        :he => [:hebrew,              :heb],
        :hz => [:herero,              :her],
        :hi => [:hindi,               :hin],
        :ho => [:hiri_motu,           :hmo],
        :hu => [:hungarian,           :hun],
        :is => [:icelandic,           :ice, :isl],
        :io => [:ido,                 :ido],
        :ig => [:igbo,                :ibo],
        :id => [:indonesian,          :ind],
        :ia => [:interlingua,         :ina],
        :ie => [:interlingue,         :ile],
        :iu => [:inuktitut,           :iku],
        :ik => [:inupiaq,             :ipk],
        :ga => [:irish,               :gle],
        :it => [:italian,             :ita],
        :ja => [:japanese,            :jpn],
        :jv => [:javanese,            :jav],
        :kl => [:kalaallisut,         :kal],
        :kn => [:kannada,             :kan],
        :kr => [:kanuri,              :kau],
        :ks => [:kashmiri,            :kas],
        :kk => [:kazakh,              :kaz],
        :ki => [:kikuyu,              :kik],
        :rw => [:kinyarwanda,         :kin],
        :ky => [:kirghiz,             :kir],
        :kv => [:komi,                :kom],
        :kg => [:kongo,               :kon],
        :ko => [:korean,              :kor],
        :kj => [:kuanyama,            :kua],
        :ku => [:kurdish,             :kur],
        :kj => [:kwanyama,            :kua],
        :ky => [:kyrgyz,              :kir],
        :lo => [:lao,                 :lao],
        :la => [:latin,               :lat],
        :lv => [:latvian,             :lav],
        :lb => [:letzeburgesch,       :ltz],
        :li => [:limburgan,           :lim],
        :li => [:limburger,           :lim],
        :li => [:limburgish,          :lim],
        :ln => [:lingala,             :lin],
        :lt => [:lithuanian,          :lit],
        :lu => [:luba_katanga,        :lub],
        :lb => [:luxembourgish,       :ltz],
        :mk => [:macedonian,          :mac, :mkd],
        :mg => [:malagasy,            :mlg],
        :ms => [:malay,               :may, :msa],
        :ml => [:malayalam,           :mal],
        :dv => [:maldivian,           :div],
        :mt => [:maltese,             :mlt],
        :gv => [:manx,                :glv],
        :mi => [:maori,               :mao, :mri],
        :mr => [:marathi,             :mar],
        :mh => [:marshallese,         :mah],
        :ro => [:moldavian,           :rum, :ron],
        :ro => [:moldovan,            :rum, :ron],
        :mn => [:mongolian,           :mon],
        :na => [:nauru,               :nau],
        :nv => [:navaho,              :nav],
        :nv => [:navajo,              :nav],
        :ng => [:ndonga,              :ndo],
        :ne => [:nepali,              :nep],
        :nd => [:north_ndebele,       :nde],
        :se => [:northern_sami,       :sme],
        :no => [:norwegian,           :nor],
        :ii => [:nuosu,               :iii],
        :ny => [:nyanja,              :nya],
        :nn => [:nynorsk,             :nno],
        :ie => [:occidental,          :ile],
        :oc => [:occitan,             :oci],
        :oj => [:ojibwa,              :oji],
        :cu => [:old_church_slavonic, :chu],
        :or => [:oriya,               :ori],
        :om => [:oromo,               :orm],
        :os => [:ossetian,            :oss],
        :os => [:ossetic,             :oss],
        :pi => [:pali,                :pli],
        :pa => [:panjabi,             :pan],
        :ps => [:pashto,              :pus],
        :fa => [:persian,             :per, :fas],
        :pl => [:polish,              :pol],
        :pt => [:portuguese,          :por],
        :pa => [:punjabi,             :pan],
        :ps => [:pushto,              :pus],
        :qu => [:quechua,             :que],
        :ro => [:romanian,            :rum, :ron],
        :rm => [:romansh,             :roh],
        :rn => [:rundi,               :run],
        :ru => [:russian,             :rus],
        :sm => [:samoan,              :smo],
        :sg => [:sango,               :sag],
        :sa => [:sanskrit,            :san],
        :sc => [:sardinian,           :srd],
        :gd => [:scottish_gaelic,     :gla],
        :sr => [:serbian,             :srp],
        :sn => [:shona,               :sna],
        :ii => [:sichuan_yi,          :iii],
        :sd => [:sindhi,              :snd],
        :si => [:sinhala,             :sin],
        :si => [:sinhalese,           :sin],
        :sk => [:slovak,              :slo, :slk],
        :sl => [:slovenian,           :slv],
        :so => [:somali,              :som],
        :st => [:sotho,               :sot],
        :nr => [:south_ndebele,       :nbl],
        :es => [:spanish,             :spa],
        :su => [:sundanese,           :sun],
        :sw => [:swahili,             :swa],
        :ss => [:swati,               :ssw],
        :sv => [:swedish,             :swe],
        :tl => [:tagalog,             :tgl],
        :ty => [:tahitian,            :tah],
        :tg => [:tajik,               :tgk],
        :ta => [:tamil,               :tam],
        :tt => [:tatar,               :tat],
        :te => [:telugu,              :tel],
        :th => [:thai,                :tha],
        :bo => [:tibetan,             :tib, :bod],
        :ti => [:tigrinya,            :tir],
        :to => [:tonga,               :ton],
        :ts => [:tsonga,              :tso],
        :tn => [:tswana,              :tsn],
        :tr => [:turkish,             :tur],
        :tk => [:turkmen,             :tuk],
        :tw => [:twi,                 :twi],
        :ug => [:uighur,              :uig],
        :uk => [:ukrainian,           :ukr],
        :ur => [:urdu,                :urd],
        :ug => [:uyghur,              :uig],
        :uz => [:uzbek,               :uzb],
        :ca => [:valencian,           :cat],
        :ve => [:venda,               :ven],
        :vi => [:vietnamese,          :vie],
        :vo => [:volapuk,             :vol],
        :wa => [:walloon,             :wln],
        :cy => [:welsh,               :wel, :cym],
        :fy => [:western_frisian,     :fry],
        :wo => [:wolof,               :wol],
        :xh => [:xhosa,               :xho],
        :yi => [:yiddish,             :yid],
        :yo => [:yoruba,              :yor],
        :za => [:zhuang,              :zha],
        :zu => [:zulu,                :zul]
      }

      # Finds the two-letter code for the specified language.
      #
      #   Language.find(:english)  # => :en
      #   Language.find(:eng)      # => :en
      #   Language.find(:en)       # => :en
      #   Language.find(:japanese) # => :ja
      #   Language.find(:klingon)  # => raises Konjac::InvalidLanguageError
      def find(lang)
        # Allow function to accept both symbol and string arguments
        lang = lang.to_sym

        if LIST.has_key?(lang)
          # Shortcut for two-letter language codes
          return lang
        else
          # Breaks away automatically if a match is found
          LIST.each do |two_letter_code, alt_names|
            return two_letter_code if alt_names.include?(lang)
          end

          # Return nil if nothing found
          raise InvalidLanguageError.new("Language not found: #{lang}")
        end
      end

      # Determine whether the specified language has spaces or not
      def has_spaces?(two_letter_code)
        !LANGUAGES_WITHOUT_SPACES.include?(two_letter_code.to_sym)
      end

      private

      # Convert to underscore case
      def underscore(str)  # :doc:
        str.to_s.                               # allow symbols and strings
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').  # underscore-delimit caps
        gsub(/([a-z\d])\s?([A-Z])/, '\1_\2').   # underscore-delimit words
        tr("-", "_").                           # dashes to underscores
        downcase.                               # everything lowercase
        to_sym                                  # convert to symbol
      end
    end
  end
end
