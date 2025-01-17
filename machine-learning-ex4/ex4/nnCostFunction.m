function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%

for i = 1:m,

	a1 = [1;X(i,:)']; %first activation ((input_layer_size + 1) X 1)
	a2 = [1;sigmoid(Theta1*a1)]; %second activation ((hidden_layer_size + 1) X 1)
	h = sigmoid(Theta2*a2); %third activation (num_labels X 1)

	label = zeros(num_labels,1); %Initialize vector (num_labels X 1)
  label(y(i)) = 1; %Label yth element {0;0;0;0;1;0;0;0;0;0}

  %backpropagation
  delta3 = h - label; % num_labels X 1
  delta2 = Theta2'*delta3.*a2.*(1-a2); % (hidden_layer_size + 1) X 1

  %delta matrix "accumulator"
  Theta2_grad += 1/m * delta3*a2'; % num_labels X (hidden_layer_size + 1)
  Theta1_grad += 1/m * delta2(2:end)*a1'; %hidden_layer_size X (input_layer_size + 1)

  %cost function
	J += 1/m * sum(-label.*log(h) - (1-label).*log(1-h));

end;

%regularized term: square sum of all theta terms excluding bias terms
theta_sumsq = sum(sumsq(Theta1(:,[2:end]))) + sum(sumsq(Theta2(:,[2:end])));

%add regularized term to cost function
J += lambda/(2*m) * theta_sumsq;


%add regularized term to theta gradients
Theta2_grad += lambda/m *[zeros(size(Theta2),1),Theta2(:,[2:end])];
Theta1_grad += lambda/m *[zeros(size(Theta1),1),Theta1(:,[2:end])];
%setting the first col of theta to zeros so the bias units dont add up


% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
