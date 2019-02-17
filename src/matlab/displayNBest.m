function displayNBest(sentences, sortedidxs, normlogprobs, nbest, pattern)
    n=1;
    for h=1:length(sortedidxs)
        if isempty(regexp(sentences{sortedidxs(h)}, pattern, 'once'))
            continue
        end
        disp([num2str(h) ': ' sentences{sortedidxs(h)} ' ' num2str(normlogprobs(sortedidxs(h)))]);
        n=n+1;
        if n>nbest
            break
        end
    end
end