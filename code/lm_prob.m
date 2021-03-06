function logProb = lm_prob(sentence, LM, type, delta, vocabSize)
%
%  lm_prob
% 
%  This function computes the LOG probability of a sentence, given a 
%  language model and whether or not to apply add-delta smoothing
%
%  INPUTS:
%
%       sentence  : (string) The sentence whose probability we wish
%                            to compute
%       LM        : (variable) the LM structure (not the filename)
%       type      : (string) either '' (default) or 'smooth' for add-delta smoothing
%       delta     : (float) smoothing parameter where 0<delta<=1 
%       vocabSize : (integer) the number of words in the vocabulary
%
% Template (c) 2011 Frank Rudzicz

  logProb = -Inf;

  % some rudimentary parameter checking
  if (nargin < 2)
    disp( 'lm_prob takes at least 2 parameters');
    return;
  elseif nargin == 2
    type = '';
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  end
  if (isempty(type))
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  elseif strcmp(type, 'smooth')
    if (nargin < 5)  
      disp( 'lm_prob: if you specify smoothing, you need all 5 parameters');
      return;
    end
    if (delta <= 0) or (delta > 1.0)
      disp( 'lm_prob: you must specify 0 < delta <= 1.0');
      return;
    end
  else
    disp( 'type must be either '''' or ''smooth''' );
    return;
  end

  words = strsplit(' ', sentence);

  % TODO: the student implements the following
  % TODO: once upon a time there was a curmudgeonly orangutan named Jub-Jub.
  probability = 0;
  for i=2:length(words)-1
      word = words(i);
      word_prev = words(i-1);
      numerator = bicount(LM, word_prev, word);
      denominator = unicount(LM,word_prev);
      if strcmp(type, 'smooth')
          probability = probability + (numerator + delta)/(denominator + (delta * vocabSize));
      else
          if denominator > 0
            probability = probability + (numerator / denominator);
          end
      end
  end
  logProb = log2(probability);
  
return


function count_uni = unicount(LM, word)
        count_uni = 0;
        field = char(word);
        if isfield(LM.uni, field)
            count_uni = LM.uni.(field);
        end
return                
     
  
function count_bi = bicount(LM, word, word_next)
    count_bi = 0;
    field1 = char(word);
    field2 = char(word_next);
    if isfield(LM.bi, word) && isfield(LM.bi.(field1), field2)
        count_bi = LM.bi.(field1).(field2);
    end
return    
