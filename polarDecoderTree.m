function [u,x] = polarDecoderTree(y,f)
% y = bit APP from channel in output order % f = input a priori probs in input order
% x = output hard decision in output order % u = input hard decisions in input order

N = length(y);
if (N == 1)
    if (f==1/2) % info bit
        x = y; u=x;
    else % frozen bit
        x = f; u = f;
    end
else
    % left child
    u1est = cnop(y(1:2:end),y(2:2:end));
    [uhat1,u1hardprev] = polarDecoderTree(u1est,f(1:(N/2)));
    % right child
    u2est = vnop(cnop(u1hardprev,y(1:2:end)),y(2:2:end));
    [uhat2,u2hardprev] = polarDecoderTree(u2est,f((N/2+1):end));

    % parent node
    u = [uhat1 uhat2];
    x = reshape([cnop(u1hardprev,u2hardprev); u2hardprev],1,[]);
end


end

% Check node operation
% function z = cnop(w1,w2)
%     z = w1 .* (1-w2) + w2 .* (1-w1); 
% end
% % Repetition node operation
% function z = vnop(w1,w2)
%     z = w1 .* w2 ./  (w1.*w2 + (1-w1).*(1-w2)); 
% end

% f function for BEC
function output = cnop(L1,L2)
%% ======== True Table =======
%    output        L1       L2 
%       0           0        0
%       0           1        1
%       1           0        1
%       1           1        0
%       nan       nan/dc    nan/dc
% *dc: indicates dont-care if one of the inputs is erasure
% *    recall that we can only decode if both inputs are nonerasures
numXOR = length(L1);
output = zeros(1,numXOR);
for i=1:numXOR
    if (isnan(L1(i)) || isnan(L2(i)))
        output(i) = nan;
    else
        output(i) = xor(L1(i),L2(i));
    end

end
end

function output = vnop(L1,L2)
% We assume that u1 must be available to us
% We can decode if either L1 or L2 is available
% if L1 || L2 = 0: u2 =>  u1 
% if L1 || L2 = 1: u2 => ~u1
numDecisions = length(L1); % so-called repetition code approach
output = zeros(1,numDecisions);
for i=1:numDecisions
    if ~isnan(L1(i))
        output(i) = L1(i);
    elseif ~isnan(L2(i))
        output(i) = L2(i);
    else
        output(i) = nan;
    end
end
end





