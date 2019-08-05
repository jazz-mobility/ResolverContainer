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

            context("when registered resolver") {

                var instance: TestValue!

                beforeEach {
                    let object = TestValue()
                    instance = object
                    container.register { object }
                }

                it("can resolve it later") {
                    expect(try! container.resolve(TestValue.self)).to(beIdenticalTo(instance))

                    let object: TestTest<Int> = try! container.resolve()
                    expect(object).to(beIdenticalTo(instance))
                }

                context("and unregistered object") {

                    beforeEach {
                        container.unregister(TestTest<Int>.self)
                    }

                    it("fails to resolve the type") {
                        do {
                            let _ = try container.resolve(TestValue.self)
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest")))
                        }

                        do {
                            let _: TestTest<Int> = try container.resolve()
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest")))
                        }
                    }
                }
            }

            context("when registered instance") {

                var instance: TestValue!

                beforeEach {
                    let object = TestValue()
                    instance = object
                    container.register(instance: object)
                }

                it("can resolve it later") {
                    expect(try! container.resolve(TestValue.self)).to(beIdenticalTo(instance))

                    let object: TestTest<Int> = try! container.resolve()
                    expect(object).to(beIdenticalTo(instance))
                }

                context("and unregistered object") {

                    beforeEach {
                        container.unregister(TestTest<Int>.self)
                    }

                    it("fails to resolve the type") {
                        do {
                            let _ = try container.resolve(TestValue.self)
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest")))
                        }

                        do {
                            let _: TestTest<Int> = try container.resolve()
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest")))
                        }
                    }
                }
            }
        }
    }
}

class TestTest<Value> {}

typealias TestValue = TestTest<Int>
