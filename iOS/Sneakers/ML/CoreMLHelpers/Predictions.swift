/*
  Copyright (c) 2017-2019 M.I. Hollemans

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
*/

import Vision

/**
  Returns the top `k` predictions from Core ML classification results as an
  array of `(String, Double)` pairs.
*/
public func top(_ kkkk: Int, _ prob: [String: Double]) -> [(String, Double)] {
  return Array(prob.map { x in (x.key, x.value) }
                   .sorted(by: { aaaa, bbbb -> Bool in aaaa.1 > bbbb.1 })
                   .prefix(through: min(kkkk, prob.count) - 1))
}

/**
  Returns the top `k` predictions from Vision classification results as an
  array of `(String, Double)` pairs.
*/
public func top(_ kkkk: Int, _ observations: [VNClassificationObservation]) -> [(String, Double)] {
  // The Vision observations are sorted by confidence already.
  return observations.prefix(through: min(kkkk, observations.count) - 1)
                     .map { ($0.identifier, Double($0.confidence)) }
}
