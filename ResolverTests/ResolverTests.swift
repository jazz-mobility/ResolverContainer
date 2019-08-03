//
//  ResolverTests.swift
//  ResolverTests
//
//  Created by Natan Zalkin on 02/08/2019.
//  Copyright © 2019 Natan Zalkin. All rights reserved.
//

import Quick
import Nimble

@testable import Resolver

class ResolverTests: QuickSpec {
    override func spec() {
        describe("ResolverContainer") {
            var container: ResolverContainer!

            beforeEach {
                container = ResolverContainer()
            }

            context("when registered object") {

                var instance: TestTest!

                beforeEach {
                    let object = TestTest()
                    instance = object
                    container.register { object }
                }

                it("can resolve it later") {
                    expect(try! container.resolve(TestTest.self)).to(beIdenticalTo(instance))

                    let object: TestTest = try! container.resolve()
                    expect(object).to(beIdenticalTo(instance))
                }

                context("and unregistered object") {

                    beforeEach {
                        container.unregister(TestTest.self)
                    }

                    it("fails to resolve the type") {
                        do {
                            let _ = try container.resolve(TestTest.self)
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest")))
                        }

                        do {
                            let _: TestTest = try container.resolve()
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest")))
                        }
                    }
                }
            }
        }
    }
}

class TestTest {}
